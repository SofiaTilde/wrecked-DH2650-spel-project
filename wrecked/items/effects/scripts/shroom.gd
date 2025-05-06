extends Item

func _ready():
	labelText = "Shroom"
	icon = preload("res://items/shroom/shroom_icon.png") as Texture2D

func activateItem():
	var player = detectHitPlayer()
	if player == null:
		return