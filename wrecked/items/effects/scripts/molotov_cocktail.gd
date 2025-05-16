extends Item

var frame1: Texture2D
var frame2: Texture2D
var frame3: Texture2D
var frame4: Texture2D
var frame5: Texture2D

func _ready():
	labelText = "Molotov Cocktail"
	icon = preload("res://items/molotov_cocktail/molotov_cocktail_icon.png") as Texture2D
	frame1 = preload("res://items/effects/textures/fire/1.png") as Texture2D
	frame2 = preload("res://items/effects/textures/fire/2.png") as Texture2D
	frame3 = preload("res://items/effects/textures/fire/3.png") as Texture2D
	frame4 = preload("res://items/effects/textures/fire/4.png") as Texture2D
	frame5 = preload("res://items/effects/textures/fire/5.png") as Texture2D
	overlayTexture = frame1

func activateItem():
	var player = detectHitPlayer()
	if player == null:
		return
	var frameLength = 0.1;
	for i in range(10):
		overlayTexture = frame1
		await applyOverlay(player, 0.1)
		overlayTexture = frame2
		await applyOverlay(player, 0.1)
		overlayTexture = frame3
		await applyOverlay(player, 0.1)
		overlayTexture = frame4
		await applyOverlay(player, 0.1)
		overlayTexture = frame5
		await applyOverlay(player, 0.1)
