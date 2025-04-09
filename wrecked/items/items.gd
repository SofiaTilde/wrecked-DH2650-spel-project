extends Node3D
class_name ItemProvider

@export var eyepatch: PackedScene
@export var noteyepatch: PackedScene

var itemlist: Array = []

func _ready():
	randomize()

func get_item():
	if itemlist.is_empty():
		itemlist = [eyepatch, noteyepatch]
	return itemlist.pick_random()
