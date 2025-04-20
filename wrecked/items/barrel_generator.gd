extends Node3D

@onready var barrel_scene = preload("res://items/barrel.tscn")
var rng = RandomNumberGenerator.new()
enum BarrelLevel {Copper, Silver, Gold}

func _ready():
	rng.randomize()
	for n in range(7):
		createBarrel(rng.randf_range(-20.0, 20.0), rng.randf_range(-20.0, 20.0), BarrelLevel.Copper)
		createBarrel(rng.randf_range(-20.0, 20.0), rng.randf_range(-20.0, 20.0), BarrelLevel.Silver)
		createBarrel(rng.randf_range(-20.0, 20.0), rng.randf_range(-20.0, 20.0), BarrelLevel.Gold)

func createBarrel(x, z, level):
	var barrel = barrel_scene.instantiate()
	add_child(barrel)
	barrel.barrelStart(x, z, level)
