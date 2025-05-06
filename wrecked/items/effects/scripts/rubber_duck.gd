extends Item

func _ready():
	labelText = "Rubber Duck"
	icon = preload("res://items/rubber_duck/rubber_duck_icon.png") as Texture2D

func activateItem():
	var player = detectHitPlayer()
	if player == null:
		return