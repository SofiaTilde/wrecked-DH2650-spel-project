@tool   # visible in editor
extends Node3D

@export var platform_scenes: Array[PackedScene]
@export var randomize_in_editor := false

@export var min_distance := 2.5
@export var max_distance := 5.0

@export var max_angle := 45.0

const LEVEL_LENGTH := 256.0
const MAX_WIDTH := 16.0

func _ready() -> void:
	_spawn_platforms()

func _spawn_platforms() -> void:
	if platform_scenes.is_empty():
		push_error("No platform scenes assigned to " + name)
		return
		
	for child in get_children():
		remove_child(child)

	randomize()
	_spawn_first(Vector3(0.0, 0.0, 0.0))
	_spawn_first(Vector3(2.5, 0.0, 0.0))
	_spawn_first(Vector3(5.0, 0.0, 0.0))
	_spawn_first(Vector3(7.5, 0.0, 0.0))
	_spawn_second()

# First half of the level (from spawn)
func _spawn_first(start):
	var stack = []
	
	stack.push_back(start)

	var i = 0
	while stack.size() > 0	&& i < 1000:
		
		var current = stack.pop_back()
		
		if !_spawn_from_pos(current):
			continue
		
		var next_count = 1
		
		if randi() % 3 == 0:
			next_count = 2
		
		for j in range(next_count):
			var distance = randf() * (max_distance - min_distance) + min_distance
			var angle = (randf() * 2.0 - 1.0) * max_angle

			var shift = Vector3(sin(deg_to_rad(angle)) * distance, 0.0, -cos(deg_to_rad(angle)) * distance)
			var next_position = current + shift
			
			if next_position.z > -LEVEL_LENGTH / 2.0:
				if next_position.x < -MAX_WIDTH || next_position.x > MAX_WIDTH:
					shift.x = -shift.x
					next_position = current + shift
					
				stack.push_back(next_position)

		i = i + 1

# First half of the level (from goal)
func _spawn_second():
	var stack = []
	
	stack.push_back(Vector3(0.0, 0.0, -LEVEL_LENGTH))

	var i = 0
	while stack.size() > 0	&& i < 1000:
		
		var current = stack.pop_back()
		
		if !_spawn_from_pos(current):
			continue
		
		var next_count = 1
		
		if randi() % 2 == 0:
			next_count = 2
		
		for j in range(next_count):
			var distance = randf() * (max_distance - min_distance) + min_distance
			var angle = (randf() * 2.0 - 1.0) * max_angle

			var shift = Vector3(sin(deg_to_rad(angle)) * distance, 0.0, cos(deg_to_rad(angle)) * distance)
			var next_position = current + shift
			
			if next_position.z < -LEVEL_LENGTH / 2.0:
				if next_position.x < -MAX_WIDTH || next_position.x > MAX_WIDTH:
					shift.x = -shift.x
					next_position = current + shift
					
				stack.push_back(next_position)

		i = i + 1
	
func _spawn_from_pos(position):
	for child in get_children():

		if child is Node3D:
			var other_pos: Vector3 = (child as Node3D).global_transform.origin
			
			if position.distance_to(other_pos) < min_distance:
				
				return false

	var scene: PackedScene = platform_scenes[randi() % platform_scenes.size()]
	var platform: Node3D   = scene.instantiate()

	add_child(platform)
	platform.global_position = position
	platform.owner = owner
	
	return true

func _notification(what):
	if Engine.is_editor_hint() and what == NOTIFICATION_READY and randomize_in_editor:
		for c in get_children(): c.queue_free()
		_spawn_platforms()
