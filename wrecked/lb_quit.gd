extends Button

@onready var GM: Node = get_node("/root/Game/GameManager")
@onready var quit_button: Button = get_node("/root/Game/GameManager/CanvasLayer/opacity/Leaderboard2/MarginContainer/HBoxContainer/Quit")

func _ready():
	grab_focus()
	quit_button.pressed.connect(_button_pressed)

func _button_pressed():
	if quit_button.button_pressed: 
		get_tree().quit()
