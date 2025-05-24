extends Item

#overlayTexture = load("res://items/effects/textures/bubbles.png")


func _ready():
	labelText = "Parrot"
	icon = preload("res://items/parrot/parrot_icon.png") as Texture2D
	soundEffect= preload("res://Sounds/cartoon-jump-6462_parrot.mp3")
func activateItem():
	var player = detectHitPlayer()
	
	player.force_jump()
	
	
	if player == null:
		return
