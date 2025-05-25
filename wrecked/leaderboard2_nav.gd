extends Panel

@onready var GM: Node = get_node("/root/Game/GameManager")
@onready var Game: Node3D = get_node("/root/Game")
@onready var button_restart: Button = $MarginContainer/HBoxContainer/StartGame
@onready var button_quit: Button = $MarginContainer/HBoxContainer/Quit

#$MarginContainer/HBoxContainer/StartGame
#$MarginContainer/HBoxContainer/Quit


func _ready() -> void:
	grab_focus()


#pauses the game if the 
func _process(delta: float) -> void:
	if GM.state == GM.GameState.GAMEOVER :
		#Game.process_mode = Node.PROCESS_MODE_PAUSABLE
		get_tree().paused = true	
		button_restart.grab_focus()
		button_quit.grab_focus()
	else:
		#Game.process_mode = Node.PROCESS_MODE_INHERIT
		get_tree().paused = false
