extends Area3D

@export var itemscene: PackedScene
@onready var material_copper = preload("res://items/barrel/barrel_copper.tres")
@onready var material_silver = preload("res://items/barrel/barrel_silver.tres")
@onready var material_gold = preload("res://items/barrel/barrel_gold.tres")

enum BarrelLevel {Copper, Silver, Gold}
var barrel_level = BarrelLevel.Copper

func _on_body_entered(body) -> void:
	if body is not CharacterBody3D:
		return
	var item_provider = itemscene.instantiate() as ItemProvider
	var item_packed = item_provider.get_item(barrel_level)
	var item = item_packed.instantiate()
	get_parent().add_child(item)

	item.position = self.position - Vector3(0, 0.7, 0)
	self.visible = false
	item.visible = true

	# bob item up and down
	var tween = get_tree().create_tween()
	tween.tween_property(item, "global_position", item.global_position + Vector3.UP * 1.5, 0.5) # up 1.5
	tween.tween_property(item, "global_position", item.global_position + Vector3.UP * 1, 0.25) # down  0.5
	tween.tween_property(item, "global_position", item.global_position + Vector3.UP * 1.25, 0.25) # up 0.25
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await tween.finished

	body.update_item_label(item.get_meta("item_name"))

	item.visible = false
	if is_instance_valid(item):
		item.queue_free()
	if is_instance_valid(item) and item.get_parent():
		await item.tree_exited
	await get_tree().create_timer(1).timeout
	self.queue_free()

func barrelStart(x, z, level):
	barrel_level = level
	setTexture()
	self.global_position = Vector3(x, 1.375, z)
	self.visible = true

func setTexture():
	var mesh = self.find_child("BarrelMesh") as MeshInstance3D
	if barrel_level == BarrelLevel.Gold:
		mesh.set_surface_override_material(0, material_gold)
	elif barrel_level == BarrelLevel.Silver:
		mesh.set_surface_override_material(0, material_silver)
	elif barrel_level == BarrelLevel.Copper:
		mesh.set_surface_override_material(0, material_copper)
	else: # if not gold/silver, set as copper
		barrel_level = BarrelLevel.Copper
		mesh.set_surface_override_material(0, material_copper)
