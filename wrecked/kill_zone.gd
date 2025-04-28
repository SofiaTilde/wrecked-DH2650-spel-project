extends Area3D

#notice that killzone inspector has a lower gravity also



func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		body.velocity= body.velocity*0.3 #lose speed when entering water
		body.respawn()
		
