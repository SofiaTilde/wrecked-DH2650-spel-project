extends Node3D
class_name Item

var labelText: String
var overlayTexture: Texture2D
var tempPlayer: CharacterBody3D

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
	var textureNode = player.get_node("ItemEffect/TextureRect") as TextureRect
	textureNode.texture = overlayTexture
	#leave effect for a while
	await timer(seconds)
	#remove effect
	textureNode.texture = null

func changePlayerPos(player: CharacterBody3D):
	#each item defines their own changePlayerPos function
	return
