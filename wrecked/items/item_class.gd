extends Node3D
class_name Item

var labelText: String
var overlayTextureMolo: Texture2D
var overlayTextureDynamite: Texture2D
var overlayTextureEyepatch: Texture2D
var overlayTextureDucky: Texture2D
var overlayTexture: Texture2D

var overlayRect = ColorRect
var tempPlayer: CharacterBody3D
var icon: Texture2D
var rng = RandomNumberGenerator.new()
var shaderMaterial: ShaderMaterial
enum EffectTypes { RUM, SHROOM, DUCKY }
var effect_type: EffectTypes

func throw(play: CharacterBody3D = null):
	if (play != null):
		tempPlayer = play
	self.global_position -= Vector3(0, 1, 0)
	#do throw animation
	self.visible = false
	await activateItem()
	self.queue_free()

func activateItem():
	#each item defines their own activateItem function
	return

func detectHitPlayer() -> CharacterBody3D:
	#have an detect hit that returns hit player
	#temp always player 1
	return tempPlayer

func timer(seconds):
	var timerNode = Timer.new()
	add_child(timerNode)
	timerNode.wait_time = seconds
	timerNode.one_shot = true
	timerNode.start()
	await timerNode.timeout

func applyOverlay(player: CharacterBody3D, seconds, textureNode: TextureRect,overlay):
	
	textureNode.texture = overlay
	textureNode.modulate = Color(1, 1, 1, 1) # reset needed!
	textureNode.visible = true

	#leave effect for a while
	await timer(seconds)
	textureNode.visible = false

	#remove effect

	#textureNode.texture = null

func applyOverlayFire(player: CharacterBody3D, seconds, length, i,textureNode,overlay):
	textureNode.texture = overlay
	textureNode.modulate = Color(1, 1, 1, (1-1/(length/i)) ) # opacity fadeout per call (interp 1->0)
	textureNode.visible = true

	#leave effect for a while
	await timer(seconds)
	textureNode.visible = false

	
func applyOverlayNoNull(player: CharacterBody3D, seconds, textureNode: TextureRect,overlay:Texture2D):
	textureNode.texture = overlay
	textureNode.visible = true
	textureNode.modulate = Color(1, 1, 1, 1 ) # opacity fadeout per call (interp 1->0)
	#leave effect for a while
	await timer(seconds)
	textureNode.visible = false
	
func apply_rum_effect(player: CharacterBody3D, seconds) -> void:
	var overlay = player.get_node("ItemEffect/OverlayRectRum") as ColorRect
	overlay.color   = Color(0.525, 0.68, 0.0, 0.663)
	overlay.modulate = Color(1, 1, 1, 1) # reset needed!

	overlay.visible = true
	
	# wait the effect duration
	await timer(seconds)

	#fade out
	player.get_node("ItemEffect/AnimationPlayer").play("fade_out_rum")
	await timer(3) #3 sec fadeout
	#reset
	overlay.modulate = Color(1, 1, 1, 1) # reset needed!
	overlay.visible = false
	

func apply_shroom_effect(player: CharacterBody3D, seconds) -> void:
	var overlay = player.get_node("ItemEffect/OverlayRectShroom") as ColorRect
	var ani = player.get_node("ItemEffect/AnimationPlayer")  as AnimationPlayer

	overlay.color   = Color(0.858, 0.339, 1.0, 0.678)
	overlay.modulate = Color(1, 1, 1, 1) # reset needed!	
	overlay.visible = true
	if player.player_data.placement != 4: #4th player is to short for ani currently
		ani.play("rainbow%s" %  player.player_data.placement) #play correct animation length

	
	# wait the effect duration
	await timer(seconds)

	#fade out
	player.get_node("ItemEffect/AnimationPlayer").play("fade_out_shroom")
	await timer(3) #3 sec fadeout
	#reset
	overlay.modulate = Color(1, 1, 1, 1) # reset needed!	
	overlay.visible = false


func apply_ducky_effect(player: CharacterBody3D, seconds,overlayTexture) -> void:
	var overlay = player.get_node("ItemEffect/OverlayTextureDucky") as TextureRect

	overlay.texture = overlayTexture
	overlay.modulate = Color(1, 1, 1, 1) # reset needed!	
	overlay.visible  = true
	#wait effect duration
	await timer(seconds)
	
	#fade out
	player.get_node("ItemEffect/AnimationPlayer").play("fade_out") #3 sec fadeout
	await timer(3)
	#reset
	
	overlay.modulate = Color(1, 1, 1, 1) # reset needed!
	overlay.visible = false
	overlay.texture = null
	






func applyShader(player: CharacterBody3D, seconds):
	var shaderNode = player.get_parent().get_parent().get_node("ShaderTexture") as TextureRect
	var subViewport = player.get_parent().get_parent().get_node("SubViewport") as SubViewport
	shaderNode.material = shaderMaterial
	shaderNode.visible = true
	#leave effect for a while
	await timer(seconds)
	#remove effect
	shaderNode.material = null
	shaderNode.visible = false

func changePlayerPos(player: CharacterBody3D):
	#each item defines their own changePlayerPos function
	return
