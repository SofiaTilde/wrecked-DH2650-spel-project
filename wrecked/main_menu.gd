extends Node
#@onready transitioner : Transitioner = load("res://transitioner.tscn").instantiate()
#@onready transitioner : Transitioner = get_node("/root/Level/GridContainer/SubViewportContainer/SubViewport/Player/RespawnManager/transitioner")
#var transitioner : Transitioner
#@onready var transitioner : Transitioner = $transitioner
@onready var aniPlayer : AnimationPlayer = $CanvasLayer/VBoxContainer/AnimationPlayer

#func _ready():
	#transitioner = load("res://transitioner.tscn").instantiate()
	#$"..".add_child(transitioner)
	
func start_game():
	#transitioner.set_next_animation(true)
	#await get_tree().create_timer(1.5).timeout
	global_transitioner.set_next_animation(true) #global needed for it to be visible between changing scenes
	aniPlayer.play("fade_out_main_menu")
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://node_3d.tscn")  # Or wherever your GameManager scene lives

func options():
	#Options stuff
	return 0

func quit_game():
	get_tree().quit()
