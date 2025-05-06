extends Item

func _ready():
	labelText = "Parrot"
	icon = preload("res://items/parrot/parrot_icon.png") as Texture2D

func activateItem():
	var player = detectHitPlayer()
	if player == null:
		return