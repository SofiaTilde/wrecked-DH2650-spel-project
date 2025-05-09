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
	var item = item_packed.instantiate() as Item
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

	body.setItem(item)
	self.queue_free()

func barrelStart(x, z, level):
	barrel_level = level
	setTexture()
	self.global_position = Vector3(x, 1.5, z)
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

func _process(delta: float) -> void:
	var pos = global_transform.origin

	pos.y = 0.0

	var time = Time.get_ticks_msec() / 1000.0

	pos.y += sin(pos.x * 0.51 + pos.z * 0.56 + time * 0.6) * 0.41;
	pos.y += sin(pos.x * 0.73 + pos.z * 0.392 + time * 0.9) * 0.35;
	pos.y += sin(pos.x * 0.398 + pos.z * 0.2 + time * 0.7) * 0.43;
	pos.y += sin(pos.x * 0.484 + pos.z * 0.82 + time * 0.82) * 0.21;
	pos.y += sin(pos.x * 0.212 + pos.z * 0.47 + time * 0.75) * 0.32;

	pos.y *= pow(clamp(1.0 - sqrt(pos.x * pos.x + pos.z * pos.z) / 128.0, 0.05, 1.0), 0.5);
	pos.y += 0.25 + 1.5 + 0.25

	global_transform.origin = pos
