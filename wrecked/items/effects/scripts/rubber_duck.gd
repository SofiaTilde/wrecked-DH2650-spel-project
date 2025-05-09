extends Item

var can_swim = false
var swimtime=[1.0,2.0,3.0,4.0] #+3 fade out time


func _ready():
	labelText = "Rubber Duck"
	icon = preload("res://items/rubber_duck/rubber_duck_icon.png") as Texture2D
	overlayTexture = load("res://items/effects/textures/bubbles.png")
	
func activateItem():
	var player = detectHitPlayer()
	
	player.player_data.can_swim=true
	print('rubberducky time')
	await applyOverlayFadeOut(player, swimtime[player.player_data.placement-1])
	print('OVER')
	player.player_data.can_swim=false
	
	if player == null:
		return
