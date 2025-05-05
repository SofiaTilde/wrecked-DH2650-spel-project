@tool # visible in editor
extends Node3D

@export var platform_scenes: Array[PackedScene]
@export var randomize_in_editor := false

func _ready() -> void:
	_spawn_platform()

func _spawn_platform() -> void:
	if platform_scenes.is_empty():
		push_error("No platform scenes assigned to " + name)
		return

	randomize()

	var idx: int = randi() % platform_scenes.size()
	var scene: PackedScene = platform_scenes[idx]

	var platform: Node3D = scene.instantiate()
	add_child(platform)
	
	platform.transform = Transform3D()
	platform.owner = owner

func _notification(what):
	if Engine.is_editor_hint() and what == NOTIFICATION_READY and randomize_in_editor:
		for c in get_children(): c.queue_free()
		_spawn_platform()
