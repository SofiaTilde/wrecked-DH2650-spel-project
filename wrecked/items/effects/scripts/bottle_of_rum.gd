extends Item

var active
var activePlayer: CharacterBody3D

func _ready():
	labelText = "Bottle of Rum"
	icon = preload("res://items/bottle_of_rum/bottle_of_rum_icon.png") as Texture2D
	shaderMaterial = preload("res://items/effects/materials/bottle_of_rum.tres") as ShaderMaterial
	active = false

func activateItem():
	activePlayer = detectHitPlayer()
	if activePlayer == null:
		return
	active = true
	await applyShader(activePlayer, rng.randf_range(5, 10))
	active = false

func _physics_process(delta):
	if active:
		activePlayer.velocity.x = - activePlayer.velocity.x * 2
		activePlayer.velocity.z = - activePlayer.velocity.z * 2
		activePlayer.move_and_slide()
		activePlayer.velocity.x = - activePlayer.velocity.x / 2
		activePlayer.velocity.z = - activePlayer.velocity.z / 2
