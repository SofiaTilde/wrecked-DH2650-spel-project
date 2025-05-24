extends Item

var can_swim = false
var swimtime=[1.0,2.0,3.0,4.0] #+3 fade out time


func _ready():
	labelText = "Rubber Duck"
	icon = preload("res://items/rubber_duck/rubber_duck_icon.png") as Texture2D
	overlayTextureDucky = load("res://items/effects/textures/bubbles.png")
	effect_type = EffectTypes.DUCKY
	
func activateItem():
	var player = detectHitPlayer()
	var textureNode = player.get_node("ItemEffect/OverlayTextureDucky") as TextureRect

	player.player_data.can_swim=true
	print('rubberducky time')
	player.get_node("SwimPlatform/CollisionShape3D").disabled=false
	await apply_ducky_effect(player, swimtime[player.player_data.placement-1],overlayTextureDucky)
	print('OVER')
	player.get_node("SwimPlatform/CollisionShape3D").disabled=true
	player.player_data.can_swim=false
	
	if player == null:
		return
