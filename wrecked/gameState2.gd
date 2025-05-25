extends Resource
class_name GameState2

@export var screen_changing: bool = false
signal screen_change_started
signal screen_change_ended

func start_screen_change():
	if !screen_changing:
		screen_changing = true
		emit_signal("screen_change_started")

func end_screen_change():
	if screen_changing:
		screen_changing = false
		emit_signal("screen_change_ended")
