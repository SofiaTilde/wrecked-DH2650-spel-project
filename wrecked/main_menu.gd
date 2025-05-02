extends Control

func _ready():
	$CanvasLayer/VBoxContainer/Button.pressed.connect(start_game)
	$CanvasLayer/VBoxContainer/Button2.pressed.connect(quit_game)

func start_game():
	get_tree().change_scene_to_file("res://level.tscn")  # Or wherever your GameManager scene lives

func options():
	#Options stuff
	return 0

func quit_game():
	get_tree().quit()
