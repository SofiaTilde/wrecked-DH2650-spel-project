extends Node

func _ready():
	pass
	
func start_game():
	get_tree().change_scene_to_file("res://node_3d.tscn")  # Or wherever your GameManager scene lives

func options():
	#Options stuff
	return 0

func quit_game():
	get_tree().quit()
