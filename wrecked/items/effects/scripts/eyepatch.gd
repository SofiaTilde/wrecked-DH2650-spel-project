extends Item

func _ready():
	labelText = "Eyepatch"
	overlayTexture = preload("res://items/effects/textures/eyepatch.png") as Texture2D
	icon = preload("res://items/eyepatch/eyepatch_icon.png") as Texture2D
	soundEffect = preload("res://Sounds/clothes-drop-2-40202_eyepatch.mp3") as AudioStream
func activateItem():
	if rng.randi() % 2 == 0:
		overlayTexture = preload("res://items/effects/textures/eyepatch2.png") as Texture2D
	var player = detectHitPlayer()
	if player == null:
		return
	await applyOverlay(player, rng.randf_range(5, 15))
