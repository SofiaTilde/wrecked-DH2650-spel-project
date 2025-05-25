extends Item

@onready var view1: Texture2D
@onready var view2: Texture2D
@onready var view3: Texture2D
@onready var view4: Texture2D
@onready var p1ItemIcon: TextureRect
@onready var p2ItemIcon: TextureRect
@onready var p3ItemIcon: TextureRect
@onready var p4ItemIcon: TextureRect
@onready var itemIcons: Array
@export var state: GameState2 = preload("res://GameState2.tres")


@onready var text1 = get_tree().root.get_node("Game/GridContainer/SubViewportContainer/ShaderTexture") as TextureRect
@onready var text2 = get_tree().root.get_node("Game/GridContainer/SubViewportContainer2/ShaderTexture") as TextureRect
@onready var text3 = get_tree().root.get_node("Game/GridContainer/SubViewportContainer3/ShaderTexture") as TextureRect
@onready var text4 = get_tree().root.get_node("Game/GridContainer/SubViewportContainer4/ShaderTexture") as TextureRect

signal screen_change_started
signal screen_change_ended


func _ready():
	labelText = "None"
	icon = null

	var player1 = get_tree().root.get_node("Game/GridContainer/SubViewportContainer/SubViewport/Player") as CharacterBody3D
	var player2 = get_tree().root.get_node("Game/GridContainer/SubViewportContainer2/SubViewport/Player2") as CharacterBody3D
	var player3 = get_tree().root.get_node("Game/GridContainer/SubViewportContainer3/SubViewport/Player3") as CharacterBody3D
	var player4 = get_tree().root.get_node("Game/GridContainer/SubViewportContainer4/SubViewport/Player4") as CharacterBody3D
	p1ItemIcon = player1.get_node("IconTexture")
	p2ItemIcon = player2.get_node("IconTexture")
	p3ItemIcon = player3.get_node("IconTexture")
	p4ItemIcon = player4.get_node("IconTexture")
	itemIcons=[p1ItemIcon,p2ItemIcon,p3ItemIcon,p4ItemIcon]



	view1 = player1.viewPortTexture
	view2 = player2.viewPortTexture
	view3 = player3.viewPortTexture
	view4 = player4.viewPortTexture
	soundEffect = preload("res://Sounds/Screenchange.wav")
	shaderMaterial = preload("res://items/effects/materials/screen_change.tres") as ShaderMaterial
func activateItem():
	state.start_screen_change()	
	await changeScreen()
	await timer(10)
	await resetScreen()
	state.end_screen_change()	


	
func play_sfx(stream: AudioStream):
	var p := AudioStreamPlayer.new()
	p.stream = stream
	add_child(p)
	p.play()
	p.finished.connect(p.queue_free)


func changeScreen():
	play_sfx(soundEffect)
	text1.visible = true
	text2.visible = true
	text3.visible = true
	text4.visible = true

	text1.material = shaderMaterial
	text2.material = shaderMaterial
	text3.material = shaderMaterial
	text4.material = shaderMaterial

	await timer(0.5)
	
	text1.texture = view4
	text2.texture = view3
	text3.texture = view2
	text4.texture = view1
	await timer(0.5)
	
	#so that items dont clash with placements-------------
	for i in range(4):
		var tex : TextureRect = itemIcons[i]
		# detect roughly which corner we’re in:
		var is_left = tex.anchor_left  < 0.5
		var is_top  = tex.anchor_top   < 0.5
		var new_preset:int
		if    is_left  and is_top:    new_preset = Control.LayoutPreset.PRESET_BOTTOM_RIGHT
		elif  (not is_left) and is_top:    new_preset = Control.LayoutPreset.PRESET_BOTTOM_LEFT
		elif  is_left  and (not is_top):  new_preset = Control.LayoutPreset.PRESET_TOP_RIGHT
		else:                         new_preset = Control.LayoutPreset.PRESET_TOP_LEFT
		# apply it, keeping the same margins (so it “jumps” to the far corner)
		tex.set_anchors_and_offsets_preset(new_preset,3,0)
		#tex.set_offsets_preset(new_preset)
	#-------------------
		

	text1.material = null
	text2.material = null
	text3.material = null
	text4.material = null

func resetScreen():
	play_sfx(soundEffect)

	text1.material = shaderMaterial
	text2.material = shaderMaterial
	text3.material = shaderMaterial
	text4.material = shaderMaterial

	await timer(0.5)
	text1.texture = view1
	text2.texture = view2
	text3.texture = view3
	text4.texture = view4
	await timer(0.5)
	
	
	#so that items dont clash with placements-------------
	for i in range(4):
		var tex : TextureRect = itemIcons[i]
		# detect roughly which corner we’re in:
		var is_left = tex.anchor_left  < 0.5
		var is_top  = tex.anchor_top   < 0.5
		var new_preset:int
		if    is_left  and is_top:    new_preset = Control.LayoutPreset.PRESET_BOTTOM_RIGHT
		elif  (not is_left) and is_top:    new_preset = Control.LayoutPreset.PRESET_BOTTOM_LEFT
		elif  is_left  and (not is_top):  new_preset = Control.LayoutPreset.PRESET_TOP_RIGHT
		else:                         new_preset = Control.LayoutPreset.PRESET_TOP_LEFT
		# apply it, keeping the same margins (so it “jumps” to the far corner)
		tex.set_anchors_and_offsets_preset(new_preset,3,0)
		#tex.set_offsets_preset(new_preset)
	#-------------------

	text1.material = null
	text2.material = null
	text3.material = null
	text4.material = null

	text1.visible = false
	text2.visible = false
	text3.visible = false
	text4.visible = false
