extends Item

func _ready():
	labelText = "Sword"
	icon = preload("res://items/sword/sword_icon.png") as Texture2D

func activateItem():
	var player = detectHitPlayer()
	if player == null:
		return