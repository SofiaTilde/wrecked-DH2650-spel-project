extends Node3D

func _process(delta: float) -> void:
	var pos = global_transform.origin
	
	pos.y = 0.0
	
	var time = Time.get_ticks_msec() / 1000.0
	
	pos.y += sin(pos.x * 0.21 + pos.z * 0.26 + time * 0.2) * 0.31;
	pos.y += sin(pos.x * 0.33 + pos.z * 0.192 + time * 0.6) * 0.25;
	pos.y += sin(pos.x * 0.198 + pos.z * 0.1 + time * 0.5) * 0.33;
	pos.y += sin(pos.x * 0.284 + pos.z * 0.42 + time * 0.82) * 0.21;
	pos.y += sin(pos.x * 0.112 + pos.z * 0.27 + time * 0.7) * 0.22;

	pos.y *= clamp(1.0 - sqrt(pos.x * pos.x + pos.z * pos.z) / 128.0, 0.0, 1.0);
	
	global_transform.origin = pos
