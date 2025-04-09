extends Node3D

#@onready var barrel = $Barrel
@onready var barrel_scene = preload("res://items/barrel.tscn")

func _ready():
	createBarrel(10, 10)
	createBarrel(-10, -10)
	createBarrel(-10, 10)
	createBarrel(10, -10)

func createBarrel(x, z):
	var barrel = barrel_scene.instantiate()
	add_child(barrel)
	barrel.global_position = Vector3(x, 1.375, z)
	barrel.visible = true
