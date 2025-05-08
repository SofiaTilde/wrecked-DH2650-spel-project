extends Item

func _ready():
	labelText = "Bottle of Rum"
	icon = preload("res://items/bottle_of_rum/bottle_of_rum_icon.png") as Texture2D

func activateItem():
	var player = detectHitPlayer()
	if player == null:
		return
