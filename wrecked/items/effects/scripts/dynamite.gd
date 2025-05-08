extends Item

func _ready():
	labelText = "Dynamite"
	icon = preload("res://items/dynamite/dynamite_icon.png") as Texture2D

func activateItem():
	var player = detectHitPlayer()
	if player == null:
		return
