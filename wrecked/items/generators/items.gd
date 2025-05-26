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

#@onready var GameManager = get_tree().get_current_scene().get_node("GameManager")
#GameManager is loaded globally and can be referenced to anywhere
@export var state: GameState2 = preload("res://GameState2.tres")

var copperItemlist: Array = []
var silverItemlist: Array = []
var goldItemlist: Array = []
enum BarrelLevel {Copper, Silver, Gold}

func _ready():
	 # react to changes
	
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

		if state.screen_changing: #cant get screen change (only one screen change at a time!)
				copperItemlist = [molotov_cocktail, dynamite, bottle_of_rum, shroom, eyepatch, anchor,parrot]
				#copperItemlist = [rubber_duck]
		
		else:
				copperItemlist = [ molotov_cocktail, dynamite, bottle_of_rum, shroom, eyepatch, anchor,parrot]
				#copperItemlist = [screen_change,rubber_duck]
		
	return copperItemlist.pick_random()

func get_silver_item():
	if silverItemlist.is_empty(): #cant get screen change (only one screen change at a time!)
		if state.screen_changing:
				silverItemlist = [molotov_cocktail, dynamite, bottle_of_rum, shroom, eyepatch, anchor,parrot]
				#silverItemlist = [rubber_duck]

		else:
				silverItemlist = [ molotov_cocktail, dynamite, bottle_of_rum, shroom, eyepatch, anchor,parrot]
				#silverItemlist = [screen_change,rubber_duck]
		
	return silverItemlist.pick_random()

func get_gold_item():
	if goldItemlist.is_empty(): #cant get screen change (only one screen change at a time!)
		if state.screen_changing:
				goldItemlist = [molotov_cocktail, dynamite, bottle_of_rum, shroom, eyepatch, anchor,parrot]
				#goldItemlist = [rubber_duck]


		else:
				goldItemlist = [ molotov_cocktail, dynamite, bottle_of_rum, shroom, eyepatch, anchor,parrot]
				#goldItemlist = [screen_change,rubber_duck]
	return goldItemlist.pick_random()
