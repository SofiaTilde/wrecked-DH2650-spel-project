extends Item

var activeTime = [6.0, 5.0, 4.0, 3.0] #player position 1, 2, 3, 4


	

func _ready():
	labelText = "Shroom"
	icon = preload("res://items/shroom/shroom_icon.png") as Texture2D
	#shaderMaterial = preload("res://items/effects/materials/shroom.tres") as ShaderMaterial

func activateItem():
	var player = detectHitPlayer()
	#var textureNode = player.get_node("ItemEffect/OverlayRectShroom") as ColorRect

	if player == null:
		return
	player.player_data.is_high=true
	#applyOverlayFadeOut(self, player, activeTime[player.player_data.placement-1]-3,textureNode,null) #-3 bcus fadeout
	apply_shroom_effect(player, activeTime[player.player_data.placement-1]-3) #-3 bcus fadeout
	await applyShader(player, 5)
	player.player_data.is_high=false
