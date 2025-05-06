extends Item

func _ready():
	labelText = "Anchor"
	icon = preload("res://items/anchor/anchor_icon.png") as Texture2D

func activateItem():
	var player = detectHitPlayer()
	if player == null:
		return
	changePlayerPos(player)

func changePlayerPos(player: CharacterBody3D):
	# sink player quickly
	player.velocity += player.get_gravity() * 2.0
