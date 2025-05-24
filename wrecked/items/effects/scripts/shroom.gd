extends Item

func _ready():
	labelText = "Shroom"
	icon = preload("res://items/shroom/shroom_icon.png") as Texture2D
	shaderMaterial = preload("res://items/effects/materials/shroom.tres") as ShaderMaterial
	soundEffect = preload("res://Sounds/plastic-crunch-83779_shroom.mp3") as AudioStream

func activateItem():
	var player = detectHitPlayer()
	if player == null:
		return
	await applyShader(player, 5)
