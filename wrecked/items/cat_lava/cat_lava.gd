extends Node3D

func _process(delta: float) -> void:
	var parent = get_parent()
	self.global_rotation = parent.global_rotation
	self.global_position.y = parent.global_position.y
