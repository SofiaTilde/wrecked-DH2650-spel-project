extends Node3D

@onready var barrel_scene = preload("res://items/barrel.tscn")
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	for n in range(20):
		createBarrel(rng.randf_range(-20.0, 20.0), rng.randf_range(-20.0, 20.0))

func createBarrel(x, z):
	var barrel = barrel_scene.instantiate()
	add_child(barrel)
	barrel.global_position = Vector3(x, 1.375, z)
	barrel.visible = true
