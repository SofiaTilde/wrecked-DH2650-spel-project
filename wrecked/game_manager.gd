extends Node
@onready var player1 = get_node("/root/Game/GridContainer/SubViewportContainer/SubViewport/Player")
@onready var player2: CharacterBody3D = get_node("/root/Game/GridContainer/SubViewportContainer2/SubViewport/Player2")
@onready var player3: CharacterBody3D = get_node("/root/Game/GridContainer/SubViewportContainer3/SubViewport/Player3")
@onready var player4: CharacterBody3D = get_node("/root/Game/GridContainer/SubViewportContainer4/SubViewport/Player4")
@onready var Goal: Area3D = get_node("/root/Game/Goal")
#used to make the staring area sink
@onready var Startingplatform: Node3D = get_node("/root/Game/Startingplatform")
@onready var Staringplatform_pos: Vector3 = Vector3(2.897,-0.69,6.992)
@onready var Staringplatform_pos_end: Vector3 = Vector3(2.897,100.69,6.992)
#safe spawns incase they drown and havent touched a new platform
@onready var default_safe_platform1: Node3D = get_node("/root/Game/Safe_spawnp1")
@onready var default_safe_platform2: Node3D = get_node("/root/Game/Safe_spawnp2")
@onready var default_safe_platform3: Node3D = get_node("/root/Game/Safe_spawnp3")
@onready var default_safe_platform4: Node3D = get_node("/root/Game/Safe_spawnp4")

var sinking_speed : float = 0.002
#@onready var label_animator: AnimationPlayer = get_node("/root/Game/SharedHudNextRace/Control/LabelAnimator") What is this used for?

@onready var leaderboard_popup: Panel = $CanvasLayer/opacity
@onready var leaderboard_menu_popup: Panel = $CanvasLayer/opacity/Leaderboard2
@onready var label: Label = $CanvasLayer/SharedLabel
@onready var label2: Label = $CanvasLayer/SharedLabel2
@onready var placement_labels: Array = [get_node("/root/Game/Placements/VBoxContainer/HBoxContainer/MarginContainer/HBoxContainer/Label"),get_node("/root/Game/Placements/VBoxContainer/HBoxContainer/MarginContainer2/HBoxContainer2/Label"),get_node("/root/Game/Placements/VBoxContainer/HBoxContainer2/MarginContainer/HBoxContainer/Label"),get_node("/root/Game/Placements/VBoxContainer/HBoxContainer2/MarginContainer2/HBoxContainer2/Label")]
@onready var placement_labels_th: Array = [get_node("/root/Game/Placements/VBoxContainer/HBoxContainer/MarginContainer/HBoxContainer/Label2"),get_node("/root/Game/Placements/VBoxContainer/HBoxContainer/MarginContainer2/HBoxContainer2/Label2"),get_node("/root/Game/Placements/VBoxContainer/HBoxContainer2/MarginContainer/HBoxContainer/Label2"),get_node("/root/Game/Placements/VBoxContainer/HBoxContainer2/MarginContainer2/HBoxContainer2/Label2")]
@onready var platforms: Node3D = get_node("/root/Game/_Node3D_144036")
@onready var leaderboard_labels: Array = [
	leaderboard_popup.get_node("Leaderboard/VBoxContainer/Score1st"),
	leaderboard_popup.get_node("Leaderboard/VBoxContainer/Score2nd"),
	leaderboard_popup.get_node("Leaderboard/VBoxContainer/Score3rd"),
	leaderboard_popup.get_node("Leaderboard/VBoxContainer/Score4th")
]

#README! Gameflow is generally:
#_on_goal_race_over->COUNTDOWN->RACEOVER(/GAMEOVER)->GET_READY->COUNT_IN->RACE->repeat
enum GameState {
	GET_READY,
	COUNTIN,
	RACE,
	GOAL,
	COUNTDOWN,
	RACEOVER,
	GAMEOVER,
	LEADERBOARD,
}

var players: Array
var state: GameState = GameState.GET_READY # first state
var countDownLen: int = 5
var leaderboardMenu = false
var starting = true
var placements_dict


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#await get_tree().process_frame
	add_child(player)
	player.volume_db = -6.0
	
	var red = PlayerData.new("Red Rogers", Color(1, 0, 0, 1))
	var pink = PlayerData.new("Pink Plunderer", Color(1, 0.5, 0.7, 1))
	var yellow = PlayerData.new("Yellow Yates", Color(1, 1, 0, 1))
	var green = PlayerData.new("Green Gabby", Color(0, 1, 0, 1))
	players = [player1, player2, player3, player4]
	
	player1.player_data = red
	player2.player_data = yellow
	player3.player_data = green
	player4.player_data = pink
	

	placements_dict = Goal.placements_dict
	await get_tree().process_frame

	get_ready()

func get_ready():
	state = GameState.GET_READY
	print("GET READY")
	
	if starting:
		global_transitioner.set_next_animation(false) # fade in game
		starting = false
	label.visible = true # !needed!!
	update_label(label, "GET READY FOR\nTHE NEXT RACE!", Color.WHITE, 75)
	
	#reset
	Goal.placement = 1
	for p in players:
		p.player_data.gotPoints = false
		p.get_node("PointsLabel").text = "Points: " + str(p.player_data.points) + " /10"
	player1.global_transform.origin = Vector3(1.175, 1.541, 5.439)
	player2.global_transform.origin = Vector3(3.675, 1.933, 5.439)
	player3.global_transform.origin = Vector3(6.175, 1.59, 5.439)
	player4.global_transform.origin = Vector3(8.675, 1.0, 5.439)
	await get_tree().create_timer(2.5).timeout
	
	start_count_in()
	
var COUNTDOWN_SOUND := preload("res://sounds/countdown.wav")

func play_sound_sfx(stream: AudioStream, scale):
	var p := AudioStreamPlayer.new()
	p.pitch_scale = scale
	p.stream = stream
	add_child(p)
	p.play()
	p.finished.connect(p.queue_free)

@onready var player := AudioStreamPlayer.new()

var GAME_SOUND := preload("res://sounds/game.ogg")
var GAME_END_SOUND := preload("res://sounds/game_end_short.ogg")

func start_count_in():
	state = GameState.COUNTIN
	print("COUNTIN")
	
	for i in range(3, 0, -1):
		play_sound_sfx(COUNTDOWN_SOUND, 1.0)
		update_label(label, "%s" % i, Color.WHITE, 500)
		await get_tree().create_timer(1).timeout
	play_sound_sfx(COUNTDOWN_SOUND, 2.0)
	
	player.stop()
	
	start_race()
	
	
func _process(delta: float) -> void:
	Startingplatform.global_position -= lerp(Staringplatform_pos,Staringplatform_pos_end,1.0)*delta*sinking_speed	
func start_race(): # from process
	state = GameState.RACE
	print("RACE STARTED")

	for p in players:
		p.get_node("PointsLabel").text=" "
	
	update_label(label, "WRECKED!", Color.WHITE, 300)
	
	print("new race-stage loaded!")
	#platforms.load_new_level()
	# Load newly generated platforms
	# var new_platforms = load("res://level/level.tscn").instantiate()
	# $"..".add_child(new_platforms)
	# new_platforms.name = "oldPlatformsLevel" # So we can reuse this func on next goal
	await get_tree().create_timer(1.).timeout
	label.visible = false
	for i in range(4):
		placement_labels[i].visible = true
		placement_labels_th[i].visible = true
	
	player.stream = GAME_SOUND
	player.play()    
	
func _on_goal_race_over() -> void:
	state = GameState.GOAL
	print("GOAL")
	
	player.stream = GAME_END_SOUND
	player.finished.connect(start_count_down)
	player.play()   
	
	#await get_tree().create_timer(5.).timeout # !needed! Winner HUDlabel is printed from Goal-scene
	#start_count_down()
	

func start_count_down():
	state = GameState.COUNTDOWN
	print("COUNTDOWN")
	
	update_label(label, " ", Color.RED, 500)
	for i in range(countDownLen, 0, -1):
		#update_label(label,"%s" % i, Color.RED*(i/countDownLen), 500)
		label.text = "%s" % i
		#label.label_settings.outline_color=Color.BLUE*(i/countDownLen)
		await get_tree().create_timer(1).timeout
	label.label_settings.outline_color = Color.BLACK
	
	#GAME or RACE over?
	if player1.player_data.points >= 10 or player2.player_data.points >= 10 or player3.player_data.points >= 10 or player4.player_data.points >= 10: # activate some function in another script/ node
		players.sort_custom(sort_by_points)
		if players[0].player_data.points != players[1].player_data.points: # check if tie-breaker is needed!
			game_over()
	else:
		race_over()
		
func race_over():
	state = GameState.RACEOVER
	print("RACE OVER")
	Startingplatform.position = Staringplatform_pos
	update_label(label, "GAME OVER", Color(1.0 / 3.0, 0.0, 0.0), 200)
	await get_tree().create_timer(3).timeout
	show_leaderboard()
	

func game_over():
	state = GameState.GAMEOVER
	print("GAME OVER")
	
	update_label(label, "Pirate %s" % players[0].player_data.name + " totally ", players[0].player_data.color * 0.5 + Color(0, 0, 0, 1), 100, Vector2(0, -250))
	label2.visible = true
	update_label(label2, "WRECKED IT!!", players[0].player_data.color, 300, Vector2(0, 90))
	await get_tree().create_timer(4).timeout
	
	leaderboardMenu = true
	show_leaderboard()
	Startingplatform.global_position = Staringplatform_pos

func show_leaderboard():
	state = GameState.LEADERBOARD
	print("LEADERBOARD")
	
	label2.visible = false
	label.visible = false
	leaderboard_popup.visible = true
	players.sort_custom(sort_by_points)
	for i in range(players.size()):
		var leaderboardText = str(i+1) +"%s" % placements_dict.get(i + 1)[0] + "- " + str(players[i].player_data.name) + " : " + str(players[i].player_data.points)
		update_label(leaderboard_labels[i], leaderboardText, players[i].player_data.color, 30)
	
	#Show menu
	if leaderboardMenu == true:
		leaderboard_menu_popup.visible = true
		leaderboard_popup.get_node("Leaderboard").position = Vector2(710, 150)
		
	#or start next race immidiatly
	else:
		await get_tree().create_timer(3).timeout
		leaderboard_popup.visible = false
		get_ready()
	
	
# === UTILITY ===

func update_label(label: Label, text: String, color: Color, size: float = 200, offset: Vector2 = Vector2(0, 0)):
	if label:
		label.text = text
		label.modulate = color
		label.label_settings.font_size = size
		label.position = offset
	else:
		print("Label not found!")
	
func sort_by_points(a, b) -> bool:
	return a.player_data.points > b.player_data.points
	
func clear_label(label: Label):
	if label:
		label.text = ""


#==== leaderboard menu buttons =====
func start_game(): # _on_StartGame_Button_Pressed
	Startingplatform.global_position = Staringplatform_pos
	leaderboardMenu = false
	leaderboard_popup.visible = false
	leaderboard_menu_popup.visible = false
	leaderboard_popup.get_node("Leaderboard").position = Vector2(710, 290) # reset
	
	# Reset points
	for p in players:
			p.player_data.points = 0
	starting = true
	global_transitioner.set_next_animation(true) # fade out
	await get_tree().create_timer(1.5).timeout

	get_ready()

func options():
	#Options stuff
	return 0

func quit_game(): # _on_Quit_Button_Pressed
	get_tree().quit()

		
#Artefact, keep for now!
#func _process(delta):
	#if countIn or GO:
		#shrinkTime += delta
		#var opacity = 1.5 - (shrinkTime)  
		#label.modulate = Color(1,1,1,opacity)  
	#if GO:
		#shrinkTime += delta
		#var shake_amount = sin(shrinkTime * 50.0) * 10.0
		#label.position.x = shake_amount
		#
	#if shrinkTime > 1.5:
		#if GO:
			#GO = false
			#label.text=" " #let gameplay start, no more labels
		#shrinkTime=0
		#label.modulate = Color(1,1,1,1)  #reset opacity
		#label.position= Vector2(0,0) # reset pos
		#if counter ==-4:
			#countIn = false
			#start_race()
