extends Item
var active: bool
var active2: bool
var activePlayer: CharacterBody3D
var velocityX: float
var velocityY: float
var velocityZ: float

func _ready():
	labelText = "Dynamite"
	icon = preload("res://items/dynamite/dynamite_icon.png") as Texture2D

func activateItem():
	activePlayer = detectHitPlayer()
	if activePlayer == null:
		return
	velocityX = 0
	velocityZ = 0
	velocityY = 0
	activePlayer.velocity = Vector3(0, 0, 0)
	active = true
	velocityY = 3
	await timer(0.2)
	velocityY = 0
	velocityX = rng.randf_range(-1, 1) * 10
	velocityZ = rng.randf_range(-1, 1) * 10
	if rng.randi() % 4 == 0: #25% chance to send forward
		velocityX = 0
		velocityZ = -6
		velocityY = 0.1
	await timer(0.3)
	velocityX = 0
	velocityZ = 0
	velocityY = -3
	await timer(0.2)
	active = false
	velocityX = 0
	velocityZ = 0
	velocityY = 0

func _physics_process(delta):
	if active:
		activePlayer.velocity += Vector3(velocityX, velocityY, velocityZ)
		activePlayer.move_and_slide()
