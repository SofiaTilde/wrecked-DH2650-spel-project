extends Area3D

@onready var count_down: Timer= $countDown
@onready var label: Label = get_node("/root/Level/CanvasLayer/Control/SharedLabel")
@onready var player1: CharacterBody3D = get_node("/root/Level/GridContainer/SubViewportContainer/SubViewport/Player")
@onready var player2: CharacterBody3D = get_node("/root/Level/GridContainer/SubViewportContainer2/SubViewport/Player2")
@onready var player3: CharacterBody3D = get_node("/root/Level/GridContainer/SubViewportContainer3/SubViewport/Player3")
@onready var player4: CharacterBody3D = get_node("/root/Level/GridContainer/SubViewportContainer4/SubViewport/Player4")

#For counting down and label text updates
var counter = 11

#For the count in
var shrinkTime=0
var starting = false
var GO = false


func _ready() -> void:
	label.visible = false

#For the count in (nextStageCountDown)
func _process(delta):
	if starting: #count in (starting next race)
		shrinkTime += delta
		var sizeFont= 1.5 - (shrinkTime)  # when delta=1.5sec size is 0 (interpolation)
		label.label_settings.font_size = 500*sizeFont 
	if GO:
		shrinkTime += delta
		var opacity = 1.5 - (shrinkTime)  
		label.modulate = Color(1,1,1,opacity)  
		var shake_amount = sin(shrinkTime * 50.0) * 10.0
		label.position.x = shake_amount
		
	if shrinkTime > 1.5:
		counter -=1
		label.text = "%s!" % counter
		label.label_settings.font_size = 500  # Reset size again, needed!
		shrinkTime=0.0
		
		if counter == 0:
			label.position= Vector2(0,100) #to center
			label.text = "GO" 
			GO = true
			starting = false
			label.label_settings.font_size = 700
			nextStage() #load nxt stage
			
		if counter == -1:
			label.text=" "
			GO = false
			label.modulate = Color(1,1,1,1)  #reset opacity
			label.position= Vector2(0,0) # reset pos
			counter=11

  
#enter goal
func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D and count_down.is_stopped():  #only first person trigger
		winnerHUD(body.player_id)
		count_down.start(5)

func winnerHUD(player_id : int):
	label.visible = true
	label.text = "Player %s" % [player_id] + " wins!"
	label.modulate = Color(1, 1, 0) # Yellow (RGB)
	label.label_settings.font_size = 100

#decides what label should next be displayed depending on counter
func _on_count_down_timeout():
	
	if counter==1:
		gameOverHUD()
	elif counter==0:
		getReadyHUD()
	elif counter == -1:
		nextStageCountDown() #jump to _process()
	else: #countdown
		counter -=1
		countDownHUD()
		count_down.start(1)

func gameOverHUD():
	label.text = "GAME OVER"
	label.modulate = Color(1/3, 0, 0)
	label.label_settings.outline_color = Color(0,0,0)
	label.label_settings.font_size = 200

	count_down.start(2)
	counter -= 1

func getReadyHUD():
	label.modulate = Color(1, 1, 1)
	label.text = "Get ready for\n the next race.."
	label.modulate = Color(1, 1, 1) # Back to white
	label.label_settings.font_size = 80
	player1.global_transform.origin= Vector3(-1,10,-1)	
	player2.global_transform.origin= Vector3(1,10,-1)
	player3.global_transform.origin= Vector3(-1,10,1)
	player4.global_transform.origin= Vector3(1,10,1)
	
	count_down.start(5)
	counter -= 1

func nextStageCountDown():
	counter +=5 #-1+5=4
	starting = true #activates _process()
	label.text = ""

func countDownHUD():
	label.text = "%s" % counter
	# Font color becomes more red as countdown decreases
	var red_intensity = clamp(1.0 - (counter / 10.0), 0, 1)
	label.modulate = Color(1-red_intensity/3, 1 - red_intensity, 1 - red_intensity) # From white to red gradually
	var scale_factor = 0.5 + (1.0 - (counter / 10.0)) * 2
	label.label_settings.font_size = scale_factor*200
	label.label_settings.outline_color = Color(0,0, red_intensity*2)

#spawns in new platforms
func nextStage():
	print("new stage!")
	# Load newly generated platforms
	var new_platforms = load("res://level_2.tscn").instantiate()
	$"..".add_child(new_platforms)
	new_platforms.name = "oldPlatformsLevel" # So we can reuse this func on next goal
