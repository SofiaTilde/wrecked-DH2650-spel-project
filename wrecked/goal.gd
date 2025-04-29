extends Area3D

@onready var count_down: Timer= $countDown
@onready var label: Label = get_node("/root/Level/CanvasLayer/Control/SharedLabel")

var counter = 10

func _ready() -> void:
	label.visible = false

func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:# and count_down.is_stopped():  #only first person trigger
		winnerHUD(body.player_id)
		count_down.start(5)

func _on_count_down_timeout():
	#diff labels depending on countdown
	if counter == -1:
		nextStage()
	elif counter==1:
		gameOverHUD()
	elif counter==0:
		getReadyHUD()
	else:
		counter -=1
		countDownHUD()
		count_down.start(1)

func nextStage():
	print("new stage!")
	label.text=" "
	get_tree().change_scene_to_file("res://level_2.tscn")

func getReadyHUD():
	label.text = "Get ready for\n the next race.."
	label.modulate = Color(1, 1, 1) # Back to white
	count_down.start(3)
	#label.scale = Vector2(0.5,0.5)
	label.label_settings.font_size = 80
	counter -= 1

func gameOverHUD():
	label.text = "GAME OVER"
	label.modulate = Color(1, 1, 1) # Back to white
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
