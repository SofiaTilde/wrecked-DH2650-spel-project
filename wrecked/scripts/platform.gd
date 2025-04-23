extends Node3D

func _physics_process(delta: float) -> void:
	var pos = global_transform.origin
	
	pos.y = -1.75
	
	var time = Time.get_ticks_msec() / 1000.0
	
	pos.y += sin(pos.x * 0.21 + pos.z * 0.15 + time * 0.5) * 0.31;
	pos.y += sin(pos.x * 0.23 + pos.z * 0.32 + time * 1.2) * 0.25;
	pos.y += sin(pos.x * 0.38 + pos.z * 0.41 + time * 0.7) * 0.33;
	pos.y += sin(pos.x * 0.24 + pos.z * 0.32 + time * 0.9) * 0.21;
	pos.y += sin(pos.x * 0.42 + pos.z * 0.2 + time * 1.5) * 0.22;
	
	global_transform.origin = pos
	
