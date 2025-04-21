extends Item

func _ready():
	labelText = "Eyepatch"

func activateItem():
	var player = detectHitPlayer()
	if player == null:
		return
	applyEffect(player)

func applyEffect(player: CharacterBody3D):
	player.update_item_label("hit player with eyepatch")
	return
