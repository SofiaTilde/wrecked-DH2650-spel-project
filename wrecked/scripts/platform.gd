extends Node3D

func _process(delta: float) -> void:
	var pos = global_transform.origin

	pos.y = 0.0
	
	var time = Time.get_ticks_msec() / 1000.0
	
	pos.y += sin(pos.x * 0.51 + pos.z * 0.56 + time * 0.6) * 0.41;
	pos.y += sin(pos.x * 0.73 + pos.z * 0.392 + time * 0.9) * 0.35;
	pos.y += sin(pos.x * 0.398 + pos.z * 0.2 + time * 0.7) * 0.43;
	pos.y += sin(pos.x * 0.484 + pos.z * 0.82 + time * 0.82) * 0.21;
	pos.y += sin(pos.x * 0.212 + pos.z * 0.47 + time * 0.75) * 0.32;

	pos.y *= clamp(1.0 - sqrt(pos.x * pos.x + pos.z * pos.z) / 128.0, 0.1, 1.0);
	
	global_transform.origin = pos
