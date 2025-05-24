extends Item

func _ready():
	labelText = "Eyepatch"
	overlayTextureEyepatch = preload("res://items/effects/textures/eyepatch.png") as Texture2D
	icon = preload("res://items/eyepatch/eyepatch_icon.png") as Texture2D

func activateItem():
	if rng.randi() % 2 == 0:
		overlayTextureEyepatch = preload("res://items/effects/textures/eyepatch2.png") as Texture2D
	var player = detectHitPlayer()
	if player == null:
		return
	
	var textureNode = player.get_node("ItemEffect/OverlayTextureEyepatch") as TextureRect
	await applyOverlay(player, rng.randf_range(5, 10),textureNode,overlayTextureEyepatch)
