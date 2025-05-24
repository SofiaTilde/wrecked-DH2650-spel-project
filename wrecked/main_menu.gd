extends Node
#@onready transitioner : Transitioner = load("res://transitioner.tscn").instantiate()
#@onready transitioner : Transitioner = get_node("/root/Level/GridContainer/SubViewportContainer/SubViewport/Player/RespawnManager/transitioner")
#var transitioner : Transitioner
#@onready var transitioner : Transitioner = $transitioner
@onready var aniPlayer: AnimationPlayer = $CanvasLayer/AnimationPlayer
var buttonsound: AudioStream = preload("res://Sounds/click.wav")
#func _ready():
	#transitioner = load("res://transitioner.tscn").instantiate()
	#$"..".add_child(transitioner)
	
func play_sfx(stream: AudioStream):
	var p := AudioStreamPlayer.new()
	p.stream = stream
	add_child(p)
	p.play()
	p.finished.connect(p.queue_free)


	
func start_game():
	play_sfx(buttonsound)
	#transitioner.set_next_animation(true)
	#await get_tree().create_timer(1.5).timeout
	global_transitioner.set_next_animation(true) # global needed for it to be visible between changing scenes
	aniPlayer.play("fade_out_main_menu")
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://node_3d.tscn") # Or wherever your GameManager scene lives

func options():
	play_sfx(buttonsound)
	#Options stuff
	return 0

func quit_game():
	play_sfx(buttonsound)

	get_tree().quit()
