extends Item
var active: bool
var active2: bool
var activePlayer: CharacterBody3D
var velocityX: float
var velocityY: float
var velocityZ: float
var frame1: Texture2D
var frame2: Texture2D
var frame3: Texture2D
var frame4: Texture2D

func _ready():
	labelText = "Dynamite"
	icon = preload("res://items/dynamite/dynamite_icon.png") as Texture2D
	frame1 = preload("res://items/effects/textures/explosion/1.png") as Texture2D
	frame2 = preload("res://items/effects/textures/explosion/2.png") as Texture2D
	frame3 = preload("res://items/effects/textures/explosion/3.png") as Texture2D
	frame4 = preload("res://items/effects/textures/explosion/4.png") as Texture2D
	soundEffect = preload("res://Sounds/musket-explosion-6383.wav.mp3") 

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
	overlayTexture = frame1
	await applyOverlayNoNull(activePlayer, 0.05)
	overlayTexture = frame2
	await applyOverlayNoNull(activePlayer, 0.05)
	overlayTexture = frame3
	await applyOverlay(activePlayer, 0.05)
	overlayTexture = frame4
	await applyOverlay(activePlayer, 0.05)
	#await timer(0.2)
	velocityY = 0
	velocityX = rng.randf_range(-1, 1) * 5
	velocityZ = rng.randf_range(-1, 1) * 5
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
