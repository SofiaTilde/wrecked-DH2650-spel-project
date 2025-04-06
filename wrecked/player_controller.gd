extends CharacterBody3D
#Använder sig av en Characterbody3d istälelt för Rigidbody3D
#För att använda gamla skriptet ändra nodtypen på player till Rigidbody3D

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
#animation player:
var ap: AnimationPlayer


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	ap = $PlaceholderCharacter/AnimationPlayer
	ap.play("Idle")  

#Returnar joystick värdet om värdet är högt nog
func apply_deadzone(value:float, deadzone:float)-> float:
		if abs(value) < CAMERA_DEADZONE:
			return 0.0
		return value
#_physics då det är en Characterbody3d
func _physics_process(delta: float) -> void:
	# Input för joystick kamera
	var joy_cam_x = apply_deadzone(Input.get_joy_axis(0, JOY_AXIS_RIGHT_X), CAMERA_DEADZONE)
	var joy_cam_y = apply_deadzone(Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y), CAMERA_DEADZONE)
	twist_input += -joy_cam_x * joystick_sensitivity
	pitch_input += -joy_cam_y * joystick_sensitivity

	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, -0.5, deg_to_rad(30))
	twist_input = 0.0
	pitch_input = 0.0


	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta *2.0

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var cam_basis: Basis = twist_pivot.global_transform.basis
	# rörelse relativt till kamera
	var forward := cam_basis.z
	var right := cam_basis.x
	var direction := (right * input_dir.x + forward * input_dir.y).normalized()
	
	#För att rotera karaktären längs riktningen hen går i
	var target_rotation = atan2(direction.x, direction.z)

	if direction:
		ap.play("Running")  
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		model.rotation.y = lerp_angle(model.rotation.y, target_rotation, delta * 10.0)

	else:
		ap.play("Idle")  
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)


	# Reset capture when closing
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	#
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			twist_input = -event.relative.x * mouse_sensitivity
			pitch_input = -event.relative.y * mouse_sensitivity
