extends Area3D

@onready var count_down: Timer = $countDown
@onready var label: Label = get_node("/root/Game/GameManager/CanvasLayer/SharedLabel")
@onready var GM: Node = get_node("/root/Game/GameManager")
@onready var placement_labels: Array = [get_node("/root/Game/Placements/VBoxContainer/HBoxContainer/MarginContainer/HBoxContainer/Label"),get_node("/root/Game/Placements/VBoxContainer/HBoxContainer/MarginContainer2/HBoxContainer2/Label"),get_node("/root/Game/Placements/VBoxContainer/HBoxContainer2/MarginContainer/HBoxContainer/Label"),get_node("/root/Game/Placements/VBoxContainer/HBoxContainer2/MarginContainer2/HBoxContainer2/Label")]
@onready var placement_labels_th: Array = [get_node("/root/Game/Placements/VBoxContainer/HBoxContainer/MarginContainer/HBoxContainer/Label2"),get_node("/root/Game/Placements/VBoxContainer/HBoxContainer/MarginContainer2/HBoxContainer2/Label2"),get_node("/root/Game/Placements/VBoxContainer/HBoxContainer2/MarginContainer/HBoxContainer/Label2"),get_node("/root/Game/Placements/VBoxContainer/HBoxContainer2/MarginContainer2/HBoxContainer2/Label2")]
@export var state: GameState2 = preload("res://GameState2.tres")


var placement = 1
var player_placements = {}
var player_keys
var placements_dict = {
	1: ["st!!!", Color(1.0, 1.0, 0.5, 1.0)],
	2: ["nd", Color(0.655, 0.745, 0.690, 1.0)],
	3: ["rd", Color(0.859, 0.631, 0.353,1.0)],
	4: ["th", Color(0.467, 0.294, 0.086,1.0)]
}


signal race_over

func _ready() -> void:
	player_placements={
	"Player": [4.0, placement_labels[0],placement_labels_th[0],GM.players[0].player_data],
	"Player2": [3.0, placement_labels[1],placement_labels_th[1],GM.players[1].player_data],
	"Player3": [2.0, placement_labels[2],placement_labels_th[2],GM.players[2].player_data],
	"Player4": [1.0, placement_labels[3],placement_labels_th[3],GM.players[3].player_data],
}
	
	label.visible = false
	player_keys = player_placements.keys()
	
func update_placements():
	for p in GM.players:
		if not p.player_data.respawning:
			player_placements[p.name][0]=p.position.distance_to(position)
		
	player_keys.sort_custom(
		func(a,b):
			return player_placements[a][0] < player_placements[b][0]
	)
	

func  update_placement_labels():
	
	var i = 1
	for key in player_keys:
		player_placements[key][1].text= str(i) #ok since they are already ordered
		player_placements[key][1].modulate = placements_dict[i][1]
		player_placements[key][2].text=placements_dict[i][0]
		player_placements[key][3].placement=i #update player_data
		i+=1 #next placement
	
	if state.screen_changing: #change pos of placements
		switch_placements("Player","Player4")
		switch_placements("Player2","Player3")

func _physics_process(delta: float) -> void:
	update_placements()
	update_placement_labels()
	
	
func play_sound_sfx(stream: AudioStream, scale):
	var p := AudioStreamPlayer.new()
	p.pitch_scale = scale
	p.stream = stream
	add_child(p)
	p.play()
	p.finished.connect(p.queue_free)
	
var REACH_GOAL_SOUND := preload("res://sounds/treasure_pickup.wav")

#enter goal
func _on_body_entered(body: Node3D) -> void:
	
	if body is CharacterBody3D and not body.player_data.gotPoints and (GM.state == GM.GameState.RACE or GM.state == GM.GameState.GOAL or GM.state == GM.GameState.COUNTDOWN):
		body.player_data.gotPoints = true
		play_sound_sfx(REACH_GOAL_SOUND,1.0)
		match placement:
			1:
				body.player_data.points += 4
				winner(body.player_data)
				winnerHUD(body.player_data)
				placement += 1
				print(body.player_data.points)
			2:
				body.player_data.points += 3
				placement += 1
			3:
				body.player_data.points += 2
				placement += 1
			4:
				body.player_data.points += 1
				GM.all_players_in_goal=true

func winner(player_data: PlayerData):
	emit_signal("race_over")
	
func winnerHUD(player_data: PlayerData):
	label.visible = true
	label.text = " %s" % [player_data.name] + " wins!"
	label.modulate = player_data.color # Yellow (RGB)
	label.label_settings.font_size = 100
	for i in range(4):
		placement_labels[i].visible = false
		placement_labels_th[i].visible = false


func switch_placements(pi,pj):
	var tempPlayer = [999.0, "hello","world",Color(1,1,1,1)]

	tempPlayer[1] = player_placements[pi][1].text
	tempPlayer[2] = player_placements[pi][2].text
	tempPlayer[3] = player_placements[pi][1].modulate	
	player_placements[pi][1].text = player_placements[pj][1].text
	player_placements[pi][2].text = player_placements[pj][2].text
	player_placements[pi][1].modulate = player_placements[pj][1].modulate
	player_placements[pj][1].text = tempPlayer[1]
	player_placements[pj][2].text = tempPlayer[2]
	player_placements[pj][1].modulate = tempPlayer[3]


	
