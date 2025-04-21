extends Item

var textureNode: TextureRect
var player: CharacterBody3D

func _ready():
	labelText = "Eyepatch"
	overlayTexture = preload("res://items/effects/textures/eyepatch.png") as Texture2D

func activateItem():
	player = detectHitPlayer()
	if player == null:
		return
	applyEffect()

func applyEffect():
	textureNode = player.get_node("ItemEffect/TextureRect")
	textureNode.texture = overlayTexture
	#add timer before remove effect
	removeEffect()

func removeEffect():
	#textureNode.texture = null
	player.update_item_label("removed eyepatch")
	queue_free()
