extends CharacterBody3D

const SPEED = 9
const GRAVITY = -9.8
const JUMP_VELOCITY = 9.5
const JUMPACCELERATION = 2.5
const JUMPDEACCELERATION = 0.5
const PUSH_FORCE = 1.6
const CAMERA_DEADZONE := 0.1
const ACCELERATION =2.5
const DEACCELERATION =1.5
const FALLMULTIPLIER = 0.5
const JUMPCUTMULTIPLIER = 0.8

var joystick_sensitivity :=0.05
var mouse_sensitivity :=0.001
var twist_input := 0.0
var pitch_input := 0.0

@onready var model = $PlaceholderCharacter
@onready var twist_pivot = $TwistPivot
@onready var pitch_pivot = $TwistPivot/PitchPivot
@onready var currItem_node = $MarginContainer/CurrItemLabel
@onready var lastSavePosition : Vector3 = global_transform.origin
@onready var respawn_manager = $RespawnManager


@export var player_id = 1 #p1 är default val! Ändra per spelar node i inspector!
@export var player_data : PlayerData
#animation player:
var ap: AnimationPlayer


func _ready():
	
	await get_tree().process_frame 

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	ap = $PlaceholderCharacter/AnimationPlayer
	currItem_node.text = "Item: "
	currItem_node.modulate = player_data.color 

#call this func when you pick up/use some item
func update_item_label(item:String)-> void:
	if currItem_node: #avoid crashes if node is removed/changed
		currItem_node.text = "Player %s" % [player_id] + " Item: %s" % [item]

#_physics då det är en Characterbody3d, kallas kontinuerligt.
func _physics_process(delta: float) -> void:

	
	# -- Camera
	
	var cam_dir = Input.get_vector("camera_move_right_%s" % [player_id], "camera_move_left_%s" % [player_id], "camera_move_down_%s" % [player_id], "camera_move_up_%s" % [player_id]) #normalized [-1,1] 2d vector
	twist_input += -cam_dir.x * joystick_sensitivity
	pitch_input += -cam_dir.y * joystick_sensitivity 

	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, -0.5, deg_to_rad(30)) #så kameran ej kan flippas upp och ned
	twist_input = 0.0
	pitch_input = 0.0
	var player_velocity = velocity
	var jump_state_adv = player_jump_adv(player_velocity.y,delta)

	# -- movement/running
	
	#use Input Map
	var input_dir := Vector2.ZERO
	input_dir = Input.get_vector("move_left_%s" % [player_id], "move_right_%s" % [player_id], "move_forward_%s" % [player_id], "move_back_%s" % [player_id]) #vec2 (x(L/R) och zdir(forw/backw)) also is normalized [-1,1]

	var cam_basis: Basis = twist_pivot.global_transform.basis #transformera från world coords till cam coords
	# rörelse relativt till kamera
	var forward := cam_basis.z #3d vec i cams dir
	var right := cam_basis.x
	var direction := (right * input_dir.x + forward * input_dir.y).normalized() #dir man rör sig i i cam coords

	#För att rotera karaktären längs riktningen hen går i
	var target_rotation = atan2(direction.x, direction.z) #i radian, rotation angle
	
#acceleration case
	if direction != Vector3.ZERO:
		player_velocity = player_velocity.lerp(direction*SPEED, ACCELERATION*delta) #lertp from prev player_vel-> new player_vel over (delta*acc) time
		model.rotation.y = lerp_angle(model.rotation.y, target_rotation, delta * 10.0)
	
#deacceleration case
	else:
		player_velocity = player_velocity.lerp(Vector3.ZERO, DEACCELERATION*delta)
		velocity.x = move_toward(velocity.x, 0, SPEED) #redundant bcus overwritten?
		velocity.z = move_toward(velocity.z, 0, SPEED)

	velocity.x = player_velocity.x #update final value
	velocity.z = player_velocity.z
	# Jumping
	velocity.y = jump_state_adv

	# Reset capture when closing
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	if is_on_floor():
		lastSavePosition = global_transform.origin #for respawn

	
	move_and_slide() #rörelse enligt velocity mm.
	apply_push_to_other_players() #används för att sköta collisions

	#use item
	if Input.is_action_just_pressed("use_item_%s" % [player_id]):
		update_item_label(" ")


#hanterar jump logic, will adjust with button press sensitivity
func player_jump_adv(jump_velocity,delta)-> float:
	
	var is_jumping = Input.is_action_just_pressed("jump_%s" % [player_id]) and is_on_floor()
	var is_releasing_jump = Input.is_action_just_released("jump_%s" % [player_id]) and jump_velocity > 0
	if is_jumping : 
		jump_velocity += JUMP_VELOCITY
	elif not is_on_floor():
		if is_releasing_jump and jump_velocity>0:
			jump_velocity -=  GRAVITY * JUMPDEACCELERATION * delta*FALLMULTIPLIER
		else:
			jump_velocity += GRAVITY * JUMPACCELERATION * delta *JUMPCUTMULTIPLIER
	return jump_velocity

	
func apply_push_to_other_players() -> void:
	#från doc:Returns the number of times the body collided and changed direction during the last call to move_and_slide().
	var collisions_amount = get_slide_collision_count()
	#för varje collusion som sker
	for i in range(collisions_amount):
		#från doc: which contains information about a collision that occurred during the last call 
		var collision = get_slide_collision(i)
		var Collision_object = collision.get_collider()
		#Om nåt med characterbody3d träffas 
		if Collision_object is CharacterBody3D and Collision_object != self:
			#tryck bort player
			var push_normal = -collision.get_normal() 
			var relative_speed = velocity.length()
			var push_strength = relative_speed * PUSH_FORCE
			var push_force = push_normal * push_strength
			
			Collision_object.velocity.x += push_force.x
			Collision_object.velocity.z += push_force.z


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			twist_input = -event.relative.x * mouse_sensitivity
			pitch_input = -event.relative.y * mouse_sensitivity

func _on_area_3d_visibility_changed() -> void:
	pass # Replace with function body.

#--respawning, called from Kill-zone Scene script when falling into water
func respawn():
	respawn_manager.respawn()

	
