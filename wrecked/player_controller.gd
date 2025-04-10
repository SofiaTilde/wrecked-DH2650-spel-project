extends CharacterBody3D

const SPEED = 9
const JUMP_VELOCITY = 9.5
const CAMERA_DEADZONE := 0.1
var joystick_sensitivity :=0.05
var mouse_sensitivity :=0.001
var twist_input := 0.0
var pitch_input := 0.0
@onready var model = $PlaceholderCharacter

@onready var twist_pivot = $TwistPivot
@onready var pitch_pivot = $TwistPivot/PitchPivot
@onready var label_node = get_parent().get_node("Label")


@export var player_id = 1 #p1 är default val! Ändra per spelar node i inspector!

#animation player:
var ap: AnimationPlayer


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	ap = $PlaceholderCharacter/AnimationPlayer
	ap.play("Idle")
	label_node.text = "Player %s" % [player_id] + " Item: "


#call this func when you pick up/use some item
func update_item_label(item:String)-> void:
	if label_node: #avoid crashes if node is removed/changed
		label_node.text = "Player %s" % [player_id] + " Item: %s" % [item]

#_physics då det är en Characterbody3d, kallas kontinuerligt.
func _physics_process(delta: float) -> void:

	#Camera
	var cam_dir = Input.get_vector("camera_move_right_%s" % [player_id], "camera_move_left_%s" % [player_id], "camera_move_down_%s" % [player_id], "camera_move_up_%s" % [player_id]) #normalized [-1,1] 2d vector
	twist_input += -cam_dir.x * joystick_sensitivity
	pitch_input += -cam_dir.y * joystick_sensitivity

	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, -0.5, deg_to_rad(30)) #så kameran ej kan flippas upp och ned
	twist_input = 0.0
	pitch_input = 0.0

	# Gravity

	if not is_on_floor():
		velocity += get_gravity() * delta *2.0

	# Jump
	# now use Input Map
	if Input.is_action_just_pressed("jump_%s" % [player_id]) and is_on_floor():
		velocity.y = JUMP_VELOCITY
		update_item_label("Bottle of Rum") #temporary for now

	#movement/running
	#New: now use Input Map and Deadzone is set in Input Map
	var input_dir := Vector2.ZERO
	input_dir = Input.get_vector("move_left_%s" % [player_id], "move_right_%s" % [player_id], "move_forward_%s" % [player_id], "move_back_%s" % [player_id]) #vec2 (x(L/R) och zdir(forw/backw))

	var cam_basis: Basis = twist_pivot.global_transform.basis #transformera från world coords till cam coords
	# rörelse relativt till kamera
	var forward := cam_basis.z #3d vec i cams dir
	var right := cam_basis.x
	var direction := (right * input_dir.x + forward * input_dir.y).normalized() #dir man rör sig i i cam coords

	#För att rotera karaktären längs riktningen hen går i
	var target_rotation = atan2(direction.x, direction.z) #i radian, rotation angle

	if direction:
		ap.play("Running")
		velocity.x = direction.x * SPEED #L/R
		velocity.z = direction.z * SPEED #forw/backw
		model.rotation.y = lerp_angle(model.rotation.y, target_rotation, delta * 10.0)

	else:
		ap.play("Idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)


	# Reset capture when closing
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	#
	move_and_slide() #rörelse enligt velocity mm.

	#use item
	if Input.is_action_just_pressed("use_item_%s" % [player_id]):
		update_item_label(" ")


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			twist_input = -event.relative.x * mouse_sensitivity
			pitch_input = -event.relative.y * mouse_sensitivity


func _on_area_3d_visibility_changed() -> void:
	pass # Replace with function body.
