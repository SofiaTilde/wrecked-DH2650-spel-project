extends Item

func _ready():
	labelText = "Eyepatch"
	overlayTexture = preload("res://items/effects/textures/eyepatch.png") as Texture2D

func activateItem():
	var player = detectHitPlayer()
	if player == null:
		return
	changePlayerPos(get_tree().root.get_node("Level/GridContainer/SubViewportContainer2/SubViewport/Player2") as CharacterBody3D)
	await applyOverlay(player, 3.0)
