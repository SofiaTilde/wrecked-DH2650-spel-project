extends Node3D
class_name Item

var labelText: String
var overlayTexture: Texture2D
var tempPlayer: CharacterBody3D
var icon: Texture2D
var rng = RandomNumberGenerator.new()
var shaderMaterial: ShaderMaterial
var soundEffect: AudioStream
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

func applyOverlay(player: CharacterBody3D, seconds):
	var textureNode = player.get_node("ItemEffect/OverlayTexture") as TextureRect
	textureNode.texture = overlayTexture
	textureNode.modulate = Color(1, 1, 1, 1) # reset needed!
	#leave effect for a while
	await timer(seconds)
	#remove effect

	textureNode.texture = null

func applyOverlayNoNull(player: CharacterBody3D, seconds):
	var textureNode = player.get_node("ItemEffect/OverlayTexture") as TextureRect
	textureNode.texture = overlayTexture
	textureNode.modulate = Color(1, 1, 1, 1) # reset needed!
	#leave effect for a while
	await timer(seconds)

	#For applying overlay which also should fade out as item effect time is running out
func applyOverlayFadeOut(player: CharacterBody3D, seconds):
	var textureNode = player.get_node("ItemEffect/OverlayTexture") as TextureRect
	textureNode.texture = overlayTexture
	textureNode.modulate = Color(1, 1, 1, 1) # reset needed!
	#leave effect for a while
	await timer(seconds)
	#remove effect
	player.get_node("ItemEffect/AnimationPlayer").play("fade_out") #is 3.0 sec long
	await timer(3.0)

	textureNode.texture = null


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
