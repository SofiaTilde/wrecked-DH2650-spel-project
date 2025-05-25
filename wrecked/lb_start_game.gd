extends Button


@onready var GM: Node = get_node("/root/Game/GameManager")
@onready var restart_button: Button = get_node("/root/Game/GameManager/CanvasLayer/opacity/Leaderboard2/MarginContainer/HBoxContainer/StartGame")
func _ready():
	grab_focus()
	restart_button.pressed.connect(_button_pressed)

func _button_pressed():
	if restart_button.button_pressed: 
		GM.start_game()
