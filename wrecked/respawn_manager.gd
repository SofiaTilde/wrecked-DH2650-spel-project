extends Node

@onready var reset_timer : Timer = $ResetTimer
@onready var transitioner : Transitioner = $transitioner
@onready var player = get_parent()

var is_respawning: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_ResetTimer_timeout():
	lakitu()

func respawn():
	reset_timer.start(1.5) # delay in seconds before respawn
	transitioner.set_next_animation(true) #fade in

#Lakitu is a character from mario that drags you back to the course if you fall off. I.E this is a respawn functino
func lakitu(): #called after reset_timer runs out.
	transitioner.set_next_animation(false) #fade in
	player.global_transform.origin = player.lastSavePosition + Vector3(0,4,0) # reset player to lastSavePosition
	player.velocity=Vector3(0,0,0)
