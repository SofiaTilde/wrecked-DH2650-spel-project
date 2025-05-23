extends Node3D
class_name barrel_generator

@onready var barrel_scene = preload("res://items/barrel/barrel.tscn")
var rng = RandomNumberGenerator.new()
enum BarrelLevel {Copper, Silver, Gold}

#func _ready():
#	rng.randomize()
#	for n in range(10):
#		createBarrel(rng.randf_range(-10.0, 10.0), rng.randf_range(-10.0, 10.0), BarrelLevel.Copper)
#		createBarrel(rng.randf_range(-10.0, 10.0), rng.randf_range(-10.0, 10.0), BarrelLevel.Silver)
#		createBarrel(rng.randf_range(-10.0, 10.0), rng.randf_range(-10.0, 10.0), BarrelLevel.Gold)

func _ready() -> void:
	rng.randomize()

	var type = randi() % 3

	if type == 0:
		createBarrel(0.0, 0.0, BarrelLevel.Copper)

	elif type == 1:
		createBarrel(0.0, 0.0, BarrelLevel.Silver)

	elif type == 2:
		createBarrel(0.0, 0.0, BarrelLevel.Gold)

func createBarrel(x, z, level, timer = false):
	var barrel = barrel_scene.instantiate()
	if timer:
		var rng = RandomNumberGenerator.new()
		var timerNode = Timer.new()
		add_child(timerNode)
		timerNode.wait_time = rng.randf_range(5, 20)
		timerNode.one_shot = true
		timerNode.start()
		await timerNode.timeout
	add_child(barrel)
	barrel.barrelStart(x, z, level)
