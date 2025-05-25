extends Resource # I guess
class_name PlayerData

var name: String
var points: int = 0
var gotPoints: bool = false
var equipped_item: String = ""
var color: Color = Color(1, 1, 1, 1)
var respawning: bool=false
var can_swim: bool = false
var can_jump: bool=true
var on_fire: bool=false
var is_drunk: bool=false
var is_high: bool=false
var placement: int=1

func _init(_name := "", _color := Color(1, 1, 1, 1)):
	name = _name
	color = _color
