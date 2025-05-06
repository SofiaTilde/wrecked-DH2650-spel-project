extends Node3D
class_name Item

var labelText: String
var overlayTexture: Texture2D
var tempPlayer: CharacterBody3D
var icon: Texture2D
var rng = RandomNumberGenerator.new()
var shaderMaterial: ShaderMaterial

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
	#leave effect for a while
	await timer(seconds)
	#remove effect
	textureNode.texture = null

func applyShader(player: CharacterBody3D, seconds):
	var shaderNode = player.get_parent().get_parent().get_node("ShaderTexture") as TextureRect
	var subViewport = player.get_parent().get_parent().get_node("SubViewport") as SubViewport
	shaderNode.custom_minimum_size = subViewport.size
	shaderNode.expand = true
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
