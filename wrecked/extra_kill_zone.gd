extends Area3D

# This is the scene for the invisible walkable platform

# Dictionary to track each player's platform instance
var player_platforms := {}
#
#func _on_body_entered(body: Node3D) -> void:
	#if body is CharacterBody3D:
		#if body.player_data.can_swim:
			#body.player_data.can_jump=false
			#var swim_timer = get_tree().create_timer(0.4) #needed if we dont want to gain much momentum from boyancy
			#swim_timer.connect("timeout", Callable(body, "_on_swim_timer_timeout"))
		#else:
			#body.velocity = body.velocity * 0.3 # lose speed when entering water
			#body.respawn()
