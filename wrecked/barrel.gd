extends Area3D

@export var eyepatch: PackedScene
var used := false
func _on_body_entered(body: Node3D) -> void:
	if used:
		return
	used = true

	var item = eyepatch.instantiate()
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
	item.queue_free() # delete item
