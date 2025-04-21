extends Item

var textureNode: TextureRect

func _ready():
	labelText = "Eyepatch"
	overlayTexture = preload("res://items/effects/textures/eyepatch.png") as Texture2D

func activateItem():
	var player = detectHitPlayer()
	if player == null:
		return
	await applyEffect(player)

func applyEffect(player: CharacterBody3D):
	textureNode = player.get_node("ItemEffect/TextureRect")
	textureNode.texture = overlayTexture

	var timerNode = Timer.new()
	add_child(timerNode)
	timerNode.wait_time = 3.0
	timerNode.one_shot = true
	timerNode.start()
	await timerNode.timeout

	#remove effect
	textureNode.texture = null
