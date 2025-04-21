extends Node3D
class_name Item

var labelText: String
var overlayTexture: Texture2D

func throw():
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
	return get_tree().root.get_node("Level/GridContainer/SubViewportContainer/SubViewport/Player") as CharacterBody3D

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
