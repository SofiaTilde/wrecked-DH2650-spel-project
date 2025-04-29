extends Area3D

@onready var count_down: Timer= $countDown
@onready var label: Label = get_node("/root/Level/CanvasLayer/Control/SharedLabel")
@onready var player1: CharacterBody3D = get_node("/root/Level/GridContainer/SubViewportContainer/SubViewport/Player")
@onready var player2: CharacterBody3D = get_node("/root/Level/GridContainer/SubViewportContainer2/SubViewport/Player2")
@onready var player3: CharacterBody3D = get_node("/root/Level/GridContainer/SubViewportContainer3/SubViewport/Player3")
@onready var player4: CharacterBody3D = get_node("/root/Level/GridContainer/SubViewportContainer4/SubViewport/Player4")

var counter = 4
var shrinkTime=0
var starting = false
var GO = false


func _ready() -> void:
	label.visible = false

func _process(delta):
	if starting:
		shrinkTime += delta
		var sizeFont= 1.5 - (shrinkTime)  # when delta=2sec size is 0 (interpolation)
		label.label_settings.font_size = 500*sizeFont  # Yellow flash, semi-transparent
	if GO:
		shrinkTime += delta
		var opacity = 1.5 - (shrinkTime)  # when delta=2sec size is 0 (interpolation)
		label.modulate = Color(1,1,1,opacity)  
		var shake_amount = sin(shrinkTime * 50.0) * 10.0  # faster shake
		label.position.x = shake_amount
		
	if shrinkTime > 1.5:
		counter -=1
		print(str(counter) + "!!!!!!!!!!!!!!!!!!")
		label.text = "%s!" % counter
		label.label_settings.font_size = 500  # Reset size again
		shrinkTime=0.0
		
		if counter == 0:
			label.position= Vector2(0,100)
			label.text = "GO" 
			GO = true
			starting = false
			label.label_settings.font_size = 700
			nextStage()
		if counter == -1:
			label.text=" "
			GO = false
			label.modulate = Color(1,1,1,1)  #reset opacity
			label.position= Vector2(0,0) # reset pos

  
				
func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D and count_down.is_stopped():  #only first person trigger
		winnerHUD(body.player_id)
		count_down.start(5)

func _on_count_down_timeout():
	#diff labels depending on countdown
	
	if counter==1:
		gameOverHUD()
	elif counter==0:
		getReadyHUD()
	elif counter == -1:
		nextStageCountDown()
	
	else:
		counter -=1
		countDownHUD()
		count_down.start(1)

func nextStageCountDown():
	counter +=5 #=4
	starting = true
	label.text = ""
	
	
#spawns in new platforms
func nextStage():
	print("new stage!")
	#get_tree().change_scene_to_file("res://level_2.tscn")
	# Load newly generated platforms
	var new_platforms = load("res://level_2.tscn").instantiate()
	$"..".add_child(new_platforms)
	new_platforms.name = "oldPlatformsLevel" # So we can reuse this func on next goal
	

	
func getReadyHUD():
	label.modulate = Color(1, 1, 1)

	label.text = "Get ready for\n the next race.."
	label.modulate = Color(1, 1, 1) # Back to white
	count_down.start(5)
	#label.scale = Vector2(0.5,0.5)
	label.label_settings.font_size = 80
	
	player1.global_transform.origin= Vector3(-1,10,-1)	
	player2.global_transform.origin= Vector3(1,10,-1)
	player3.global_transform.origin= Vector3(-1,10,1)
	player4.global_transform.origin= Vector3(1,10,1)
	
	counter -= 1

func gameOverHUD():
	label.text = "GAME OVER"
	label.modulate = Color(1/3, 0, 0)
	count_down.start(2)
	#label.scale = Vector2(0.13,0.13) #0.75
	label.label_settings.outline_color = Color(0,0,0)

	label.label_settings.font_size = 200
	counter -= 1

	
func countDownHUD():
	label.text = "%s" % counter
	
	# Font color becomes more red as countdown decreases
	var red_intensity = clamp(1.0 - (counter / 10.0), 0, 1)
	label.modulate = Color(1-red_intensity/3, 1 - red_intensity, 1 - red_intensity) # From white to red gradually

	var scale_factor = 0.5 + (1.0 - (counter / 10.0)) * 1.5
	#label.scale = Vector2(scale_factor,scale_factor)
	label.label_settings.font_size = scale_factor*300
	label.label_settings.outline_color = Color(0,0, red_intensity*2)

func winnerHUD(player_id : int):
	label.visible = true
	label.text = "Player %s" % [player_id] + " wins!"
	label.modulate = Color(1, 1, 0) # Yellow (RGB)
	label.label_settings.font_size = 100
