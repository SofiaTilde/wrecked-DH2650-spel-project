extends Item

var active
var activePlayer: CharacterBody3D
var activeTime = [6.0, 5.0, 4.0, 3.0] #player position 1, 2, 3, 4



func _ready():
	labelText = "Bottle of Rum"
	icon = preload("res://items/bottle_of_rum/bottle_of_rum_icon.png") as Texture2D
	shaderMaterial = preload("res://items/effects/materials/bottle_of_rum.tres") as ShaderMaterial
	effect_type = EffectTypes.RUM
	active = false

func activateItem():

	activePlayer = detectHitPlayer()
	var textureNode = activePlayer.get_node("ItemEffect/OverlayRectRum") as ColorRect

	if activePlayer == null:
		return
	
	#overlayRect = activePlayer.get_node("ItemEffect/OverlayRect")
	#overlayRect.visible=true
	activePlayer.player_data.is_drunk=true
	active = true
	#applyOverlayFadeOut(self, activePlayer, activeTime[activePlayer.player_data.placement-1]-3,textureNode,null) #-3 bcus fadeout
	apply_rum_effect(activePlayer,activeTime[activePlayer.player_data.placement-1]-3)
	await applyShader(activePlayer, activeTime[activePlayer.player_data.placement - 1])
	activePlayer.player_data.is_drunk=false
	active = false


func _physics_process(delta):
	if active:
		activePlayer.velocity.x = - activePlayer.velocity.x * 2
		activePlayer.velocity.z = - activePlayer.velocity.z * 2
		activePlayer.move_and_slide()
		activePlayer.velocity.x = - activePlayer.velocity.x / 2
		activePlayer.velocity.z = - activePlayer.velocity.z / 2
