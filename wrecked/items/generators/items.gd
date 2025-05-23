extends Node3D
class_name ItemProvider

@export var eyepatch: PackedScene
@export var anchor: PackedScene
@export var rubber_duck: PackedScene
@export var dynamite: PackedScene
@export var bottle_of_rum: PackedScene
@export var molotov_cocktail: PackedScene
@export var shroom: PackedScene
@export var parrot: PackedScene
@export var sword: PackedScene
@export var screen_change: PackedScene

var copperItemlist: Array = []
var silverItemlist: Array = []
var goldItemlist: Array = []
enum BarrelLevel {Copper, Silver, Gold}

func _ready():
	randomize()

func get_item(level):
	if level == BarrelLevel.Gold:
		return get_gold_item()
	elif level == BarrelLevel.Silver:
		return get_silver_item()
	elif level == BarrelLevel.Copper:
		return get_copper_item()

func get_copper_item():
	if copperItemlist.is_empty():
		copperItemlist = [screen_change, molotov_cocktail, dynamite, bottle_of_rum, shroom, eyepatch, anchor, rubber_duck, screen_change, screen_change, molotov_cocktail, molotov_cocktail, anchor, anchor]

	return copperItemlist.pick_random()

func get_silver_item():
	if silverItemlist.is_empty():
		silverItemlist = [screen_change, molotov_cocktail, dynamite, bottle_of_rum, shroom, eyepatch, anchor, rubber_duck, molotov_cocktail, molotov_cocktail, dynamite, dynamite, shroom, shroom, eyepatch, eyepatch]

	return silverItemlist.pick_random()

func get_gold_item():
	if goldItemlist.is_empty():
		goldItemlist = [screen_change, molotov_cocktail, dynamite, bottle_of_rum, shroom, eyepatch, anchor, rubber_duck, rubber_duck, rubber_duck, dynamite, dynamite, bottle_of_rum, bottle_of_rum, shroom, shroom]

	return goldItemlist.pick_random()
