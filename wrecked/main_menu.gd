extends Node
#@onready transitioner : Transitioner = load("res://transitioner.tscn").instantiate()
#@onready transitioner : Transitioner = get_node("/root/Level/GridContainer/SubViewportContainer/SubViewport/Player/RespawnManager/transitioner")
#var transitioner : Transitioner
#@onready var transitioner : Transitioner = $transitioner
@onready var aniPlayer: AnimationPlayer = $CanvasLayer/AnimationPlayer

var CLICK_SOUND := preload("res://sounds/click.wav")
var CLICK_LIGHT := preload("res://sounds/click_light.wav")

func play_sound_sfx(stream: AudioStream):
	var p := AudioStreamPlayer.new()
	p.stream = stream
	add_child(p)
	p.play()
	p.finished.connect(p.queue_free)
	
@onready var player := AudioStreamPlayer.new()

var INTRO_SOUND := preload("res://sounds/menu_start.ogg")
var LOOP_SOUND := preload("res://sounds/menu_loop.ogg")

func _ready():
	add_child(player)
	player.volume_db = -0.5
	player.stream = INTRO_SOUND
	player.finished.connect(_on_intro_finished)
	player.play()                          # play the intro once

func _on_intro_finished() -> void:
	player.finished.disconnect(_on_intro_finished)
	player.stream = LOOP_SOUND            # swap in the looping section
	player.play()

#func _ready():
	#transitioner = load("res://transitioner.tscn").instantiate()
	#$"..".add_child(transitioner)
	
func start_game():
	play_sound_sfx(CLICK_SOUND)
	#transitioner.set_next_animation(true)
	#await get_tree().create_timer(1.5).timeout
	global_transitioner.set_next_animation(true) # global needed for it to be visible between changing scenes
	aniPlayer.play("fade_out_main_menu")
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://node_3d.tscn") # Or wherever your GameManager scene lives

func options():
	play_sound_sfx(CLICK_SOUND)
	#Options stuff
	return 0

func quit_game():
	play_sound_sfx(CLICK_SOUND)
	get_tree().quit()
