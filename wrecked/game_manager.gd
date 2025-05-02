extends Node
@onready var player1 =get_node("/root/Level/GridContainer/SubViewportContainer/SubViewport/Player")
@onready var player2: CharacterBody3D = get_node("/root/Level/GridContainer/SubViewportContainer2/SubViewport/Player2")
@onready var player3: CharacterBody3D = get_node("/root/Level/GridContainer/SubViewportContainer3/SubViewport/Player3")
@onready var player4: CharacterBody3D = get_node("/root/Level/GridContainer/SubViewportContainer4/SubViewport/Player4")
@onready var Goal: Area3D = get_node("/root/Level/Goal")
@onready var label_animator: AnimationPlayer = get_node("/root/Level/SharedHudNextRace/Control/LabelAnimator")

@onready var leaderboard_popup: Panel = $CanvasLayer/opacity
@onready var leaderboard_menu_popup: Panel = $CanvasLayer/opacity/Leaderboard2
@onready var label: Label = $CanvasLayer/SharedLabel
@onready var label2: Label = $CanvasLayer/SharedLabel2
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

var players : Array
var state: GameState = GameState.GET_READY #first state
var countDownLen: int = 5
var leaderboardMenu = false
var starting = true
var placements_dict = {1 : "1st", 2:"2nd", 3:"3rd" , 4:"4th"}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	
	var red = PlayerData.new("Red Rogers", Color(1, 0, 0,1))
	var pink = PlayerData.new("Pink Plunderer", Color(1, 0.5, 0.7,1))
	var yellow = PlayerData.new("Yellow Yates", Color(1, 1, 0,1))
	var green = PlayerData.new("Green Gabby", Color(0, 1, 0,1))
	players = [player1,player2,player3,player4]
	
	player1.player_data = red
	player2.player_data= yellow
	player3.player_data = green
	player4.player_data = pink

	get_ready()

func get_ready():
	state = GameState.GET_READY
	print("GET READY")
	
	if starting:
		global_transitioner.set_next_animation(false) #fade in game
		starting=false
	label.visible=true #!needed!!
	update_label(label,"GET READY FOR\nTHE NEXT RACE!", Color.WHITE,75)
	
	#reset
	Goal.placement=1
	for p in players:
		p.player_data.gotPoints=false
		p.get_node("PointsLabel").text="Points: " + str(p.player_data.points) + " /10"
	player1.global_transform.origin= Vector3(-1,10,-1)	
	player2.global_transform.origin= Vector3(1,10,-1)
	player3.global_transform.origin= Vector3(-1,10,1)
	player4.global_transform.origin= Vector3(1,10,1)
	await get_tree().create_timer(2.5).timeout
	
	start_count_in()

func start_count_in():
	state = GameState.COUNTIN
	print("COUNTIN")
	
	for i in range(3,0,-1):
		update_label(label,"%s" % i, Color.WHITE, 500)
		await get_tree().create_timer(1).timeout
	start_race()
	
		
func start_race(): #from process
	state = GameState.RACE
	print("RACE STARTED")
	
	player1.get_node("PointsLabel").text= " "
	player2.get_node("PointsLabel").text= " "
	player3.get_node("PointsLabel").text= " "
	player4.get_node("PointsLabel").text= " "
	update_label(label,"WRECKED!", Color.WHITE, 300)
	
	print("new race-stage loaded!")
	# Load newly generated platforms
	var new_platforms = load("res://level_2.tscn").instantiate()
	$"..".add_child(new_platforms)
	new_platforms.name = "oldPlatformsLevel" # So we can reuse this func on next goal
	
	await get_tree().create_timer(1.).timeout
	label.visible=false
	
	
func _on_goal_race_over() -> void:
	state=GameState.GOAL
	print("GOAL")
	await get_tree().create_timer(5.).timeout #!needed! Winner HUDlabel is printed from Goal-scene
	
	start_count_down()

func start_count_down():
	state=GameState.COUNTDOWN
	print("COUNTDOWN")
	
	update_label(label," ", Color.RED, 500)
	for i in range(countDownLen,0,-1):
		#update_label(label,"%s" % i, Color.RED*(i/countDownLen), 500)
		label.text="%s" % i
		#label.label_settings.outline_color=Color.BLUE*(i/countDownLen)
		await get_tree().create_timer(1).timeout
	label.label_settings.outline_color=Color.BLACK
	
	#GAME or RACE over?
	if player1.player_data.points >= 10 or player2.player_data.points >= 10 or player3.player_data.points >= 10 or player4.player_data.points >= 10:		#activate some function in another script/ node
		players.sort_custom(sort_by_points)
		if players[0].player_data.points != players[1].player_data.points: #check if tie-breaker is needed!
			start_next_game()
	else:
		race_over()
		
func race_over():
	state=GameState.RACEOVER
	print("RACE OVER")
	
	update_label(label,"GAME OVER", Color(1/3, 0, 0), 200)
	await get_tree().create_timer(3).timeout
	show_leaderboard()
	

func start_next_game():
	state=GameState.GAMEOVER
	print("GAME OVER")
	
	update_label(label,"Pirate %s" % players[0].player_data.name + " totally ",players[0].player_data.color*0.5+Color(0,0,0,1), 100 ,Vector2(0,-250))
	label2.visible=true
	update_label(label2,"WRECKED IT!!",players[0].player_data.color, 300 ,Vector2(0,90))
	await get_tree().create_timer(4).timeout
	
	leaderboardMenu = true
	show_leaderboard()
	
func show_leaderboard():
	state=GameState.LEADERBOARD
	print("LEADERBOARD")
	
	label2.visible=false
	label.visible=false
	leaderboard_popup.visible = true
	players.sort_custom(sort_by_points)
	for i in range(players.size()):
		var leaderboardText = "%s" % placements_dict.get(i+1)+"- "+str(players[i].player_data.name) + " : " + str(players[i].player_data.points)
		update_label(leaderboard_labels[i], leaderboardText, players[i].player_data.color,30) 
	
	#Show menu
	if leaderboardMenu==true:
		leaderboard_menu_popup.visible=true
		leaderboard_popup.get_node("Leaderboard").position=Vector2(710,150)
	#or start next race immidiatly
	else: 
		await get_tree().create_timer(3).timeout
		leaderboard_popup.visible=false
		
		get_ready()
	
	
# === UTILITY ===

func update_label(label : Label,text: String, color: Color, size: float=200,offset:  Vector2=Vector2(0,0)):
	if label:
		label.text = text
		label.modulate = color
		label.label_settings.font_size = size
		label.position= offset
	else:
		print("Label not found!")
	
func sort_by_points(a, b) -> bool:
	return a.player_data.points > b.player_data.points
	
func clear_label(label : Label):
	if label:
		label.text = ""


#==== leaderboard menu buttons =====
func start_game(): #_on_StartGame_Button_Pressed
	leaderboardMenu=false
	leaderboard_popup.visible=false
	leaderboard_menu_popup.visible=false
	leaderboard_popup.get_node("Leaderboard").position=Vector2(710,290) #reset
	
	# Reset points
	for p in players:
			p.player_data.points=0
	starting = true
	global_transitioner.set_next_animation(true) #fade out
	await get_tree().create_timer(1.5).timeout

	get_ready()

func options():
	#Options stuff
	return 0

func quit_game():  #_on_Quit_Button_Pressed
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
