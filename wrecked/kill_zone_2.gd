extends Area3D

# This is the scene for the invisible walkable platform

# Dictionary to track each player's platform instance
var player_platforms := {}

func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		body.velocity = body.velocity * 0.3 # lose speed when entering water
		body.respawn()
