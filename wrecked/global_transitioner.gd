extends Node

class_name GlobalTransitioner #needed to get into player @export

@onready var animation_rect : ColorRect = $CanvasLayer/ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_rect.visible=false

func set_next_animation(fading_out:bool):
	if(fading_out):
		$CanvasLayer/FadeAnimationPlayer.play("fade_out")
	else:
		$CanvasLayer/FadeAnimationPlayer.play("fade_in_2")
