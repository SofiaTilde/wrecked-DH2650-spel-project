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
	
	player.player_data.on_fire=true #see player_controller for effect (basically always move forward)
	
	if player == null:
		return
	var frameLength = 0.1;
	var length = rng.randi_range(10 * 10, 15 * 10) / 10;
	var tot_len=length / (frameLength * 5)
	var textureNode = player.get_node("ItemEffect/OverlayTextureMolo") as TextureRect

	for i in range(tot_len):
		if player.player_data.respawning: # fire goes out in water
			break
		if player.player_data.can_swim: # fire goes out when rubber duck is active
			break

		overlayTextureMolo = frame1
		await applyOverlayFire(player, frameLength, tot_len, (i+1),textureNode,overlayTextureMolo)
		overlayTexture = frame2
		await applyOverlayFire(player, frameLength, tot_len, (i+1),textureNode,overlayTextureMolo)
		overlayTexture = frame3
		await applyOverlayFire(player, frameLength, tot_len, (i+1),textureNode,overlayTextureMolo)
		overlayTexture = frame4
		await applyOverlayFire(player, frameLength, tot_len, (i+1),textureNode,overlayTextureMolo)
		overlayTexture = frame5
		await applyOverlayFire(player, frameLength, tot_len, (i+1),textureNode,overlayTextureMolo)
	
	textureNode.modulate = Color(1, 1, 1, 1) # reset needed!
	textureNode.texture = null
	player.player_data.on_fire=false


	
