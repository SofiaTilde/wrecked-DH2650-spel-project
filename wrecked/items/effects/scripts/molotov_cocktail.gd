extends Item

func _ready():
	labelText = "Molotov Cocktail"
	icon = preload("res://items/molotov_cocktail/molotov_cocktail_icon.png") as Texture2D
	shaderMaterial = preload("res://items/effects/materials/molotov_cocktail.tres") as ShaderMaterial

func activateItem():
	var player = detectHitPlayer()
	if player == null:
		return
	await applyShader(player, 7)
