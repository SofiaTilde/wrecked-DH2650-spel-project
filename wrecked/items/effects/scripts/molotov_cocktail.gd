extends Item

func _ready():
	labelText = "Molotov Cocktail"
	icon = preload("res://items/molotov_cocktail/molotov_cocktail_icon.png") as Texture2D

func activateItem():
	var player = detectHitPlayer()
	if player == null:
		return