extends Area3D

#@export var teleport: Node3D



func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		body.velocity= Vector3(0,0,0)
		body.lakitu()
		
	pass # Replace with function body.
