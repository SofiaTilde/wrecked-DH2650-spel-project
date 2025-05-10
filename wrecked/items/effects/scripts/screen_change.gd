extends Item

@onready var view1: Texture2D
@onready var view2: Texture2D
@onready var view3: Texture2D
@onready var view4: Texture2D
@onready var text1 = get_tree().root.get_node("Game/GridContainer/SubViewportContainer/ShaderTexture") as TextureRect
@onready var text2 = get_tree().root.get_node("Game/GridContainer/SubViewportContainer2/ShaderTexture") as TextureRect
@onready var text3 = get_tree().root.get_node("Game/GridContainer/SubViewportContainer3/ShaderTexture") as TextureRect
@onready var text4 = get_tree().root.get_node("Game/GridContainer/SubViewportContainer4/ShaderTexture") as TextureRect

func _ready():
	labelText = "None"
	icon = null
	var player1 = get_tree().root.get_node("Game/GridContainer/SubViewportContainer/SubViewport/Player") as CharacterBody3D
	var player2 = get_tree().root.get_node("Game/GridContainer/SubViewportContainer2/SubViewport/Player2") as CharacterBody3D
	var player3 = get_tree().root.get_node("Game/GridContainer/SubViewportContainer3/SubViewport/Player3") as CharacterBody3D
	var player4 = get_tree().root.get_node("Game/GridContainer/SubViewportContainer4/SubViewport/Player4") as CharacterBody3D
	view1 = player1.viewPortTexture
	view2 = player2.viewPortTexture
	view3 = player3.viewPortTexture
	view4 = player4.viewPortTexture


func activateItem():
	changeScreen()
	await timer(4)
	resetScreen()

func changeScreen():
	text1.visible = true
	text2.visible = true
	text3.visible = true
	text4.visible = true

	text1.texture = view4
	text2.texture = view3
	text3.texture = view2
	text4.texture = view1

func resetScreen():
	text1.visible = false
	text2.visible = false
	text3.visible = false
	text4.visible = false

	text1.texture = view1
	text2.texture = view2
	text3.texture = view3
	text4.texture = view4
