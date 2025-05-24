extends Item

func _ready():
	labelText = "Anchor"
	icon = preload("res://items/anchor/anchor_icon.png") as Texture2D
	soundEffect = preload("res://Sounds/anchor.wav")


func activateItem():
	var player = detectHitPlayer()
	if player == null:
		return
	changePlayerPos(player)

func changePlayerPos(player: CharacterBody3D):
	# sink player quickly
	player.velocity += player.get_gravity() * 3.0
