extends Node

@onready var reset_timer: Timer = $ResetTimer
@onready var transitioner: Transitioner = $transitioner
@onready var player = get_parent()

var is_respawning: bool = false
var respawntime_by_placement= [3.5,2.5,1.8,1.5]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_ResetTimer_timeout():
	lakitu()

func respawn(placement):
	
	reset_timer.start(respawntime_by_placement[placement-1]) # delay before lakitu depend on placement
	transitioner.set_next_animation(true) # fade out

#Lakitu is a character from mario that drags you back to the course if you fall off. I.E this is a respawn functino
func lakitu(): # called after reset_timer runs out.
	transitioner.set_next_animation(false) # fade in
	player.global_transform.origin = player.last_saved_platform.global_transform.origin + Vector3(0, 4, 0) # reset player to lastSavePosition
	player.velocity = Vector3(0, 0, 0)
