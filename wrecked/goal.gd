extends Area3D

@onready var count_down: Timer= $countDown
@onready var label: Label = get_node("/root/Level/GameManager/CanvasLayer/SharedLabel")


var placement = 1
var players : Array

signal race_over

func _ready() -> void:
	label.visible = false



  
#enter goal
func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D and not body.player_data.gotPoints:
		body.player_data.gotPoints=true
		match placement:
			1: 
				body.player_data.points +=3
				winner(body.player_data)
				winnerHUD(body.player_data)
				placement +=1
				print(body.player_data.points)
			2:
				body.player_data.points +=2
				placement +=1
			3:
				body.player_data.points +=1
				placement +=1

func winner(player_data : PlayerData):
	emit_signal("race_over")
	
func winnerHUD(player_data : PlayerData):
	label.visible = true
	label.text = " %s" % [player_data.name] + " wins!"
	label.modulate = player_data.color # Yellow (RGB)
	label.label_settings.font_size = 100
