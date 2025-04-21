extends Item

func _ready():
	labelText = "Eyepatch"
	overlayTexture = preload("res://items/effects/textures/eyepatch.png") as Texture2D

func activateItem():
	var player = detectHitPlayer()
	if player == null:
		return
	await applyOverlay(player, 3.0)
