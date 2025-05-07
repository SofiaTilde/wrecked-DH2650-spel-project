extends CharacterBody3D

const SPEED = 9
const GRAVITY = -9.8
const JUMP_VELOCITY = 9.5
const JUMPACCELERATION = 2.5
const JUMPDEACCELERATION = 4.5
const PUSH_FORCE = 0.8
const CAMERA_DEADZONE := 0.1
const ACCELERATION = 2.5
const DEACCELERATION = 8.5
const FALLMULTIPLIER = 0.5
const JUMPCUTMULTIPLIER = 0.8
const PUSH_COOLDOWN = 0.2 # seconds
var joystick_sensitivity := 0.05
var mouse_sensitivity := 0.001

var twist_input := 0.0
var pitch_input := 0.0
var recently_pushed = {}

@onready var model = Node3D
@onready var animation_player = AnimationPlayer
@onready var animation_tree := AnimationTree
@onready var state_machine = $"AnimationTree"["parameters/playback"]
@onready var twist_pivot = $TwistPivot
@onready var pitch_pivot = $TwistPivot/PitchPivot
@onready var coyote_timer = $CoyoteTimer
@onready var currItem_node = $MarginContainer/CurrItemLabel
@onready var lastSavePosition: Vector3 = global_transform.origin
@onready var respawn_manager = $RespawnManager
@onready var label: Label = get_node("/root/Game/GameManager/CanvasLayer/SharedLabel")
@onready var label_node: Label = $MarginContainer/CurrItemLabel
@onready var icon_node: TextureRect = $IconTexture

@onready var Camera = $TwistPivot/PitchPivot/Camera3D
@export var player_id = 1 # p1 är default val! Ändra per spelar node i inspector!var fall_multiplier: float = 0.5var jump_cut_multiplier: float = 0.8
@export var player_data: PlayerData
@export var camera_smoothing_rate = 0.1
#used to spawn correct character mesh
var player_names = {1:"Rackham_red",2:"Yates_yellow",3:"Gully_green",4:"Pippi_pink" }
var holdingItem: Item
#how many frames are allowed for coyote
var coyote_amount = 1
var is_coyote = false 

func _ready():
	
	var name = player_names.get(player_id)
	model = get_node(name)
	animation_player = str(name) + "/AnimationPlayer"
	await get_tree().process_frame
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	currItem_node.text = "Item: "
	currItem_node.modulate = player_data.color
	coyote_timer.wait_time = coyote_amount / 60.0


#call this func when you pick up/use some item
func update_item_label(item: String) -> void:
	if label_node: # avoid crashes if node is removed/changed
		label_node.text = "Player %s" % [player_id] + " Item: %s" % [item]

func update_icon(icon: Texture2D):
	if icon_node: # avoid crashes if node is removed/changed
		icon_node.texture = icon

#_physics då det är en Characterbody3d, kallas kontinuerligt.
func _physics_process(delta: float) -> void:
	#Coyote
	var last_floor = is_on_floor()

	#Inputs
	var cam_dir = Input.get_vector("camera_move_right_%s" % [player_id], "camera_move_left_%s" % [player_id], "camera_move_down_%s" % [player_id], "camera_move_up_%s" % [player_id]) # normalized [-1,1] 2d vector
	var input_dir := Vector2.ZERO
	input_dir = Input.get_vector("move_left_%s" % [player_id], "move_right_%s" % [player_id], "move_forward_%s" % [player_id], "move_back_%s" % [player_id]) # vec2 (x(L/R) och zdir(forw/backw))
	#Player variables
	var player_position = position
	var player_velocity = velocity
	var jump_state_adv = player_jump_adv(player_velocity.y,last_floor,is_coyote, delta)
	#Camera variables
	var cam_basis: Basis = twist_pivot.global_transform.basis # transformera från world coords till cam coords
	var camera_pos = Camera.position
	twist_input += -cam_dir.x * joystick_sensitivity
	var forward := cam_basis.z # 3d vec i cams dir
	var right := cam_basis.x
	var direction := (right * input_dir.x + forward * input_dir.y).normalized() # dir man rör sig i i cam coords
	var smooth_target_pos = global_transform.origin - (player_position * direction).normalized() * 0.1
	camera_pos = smooth_target_pos
	twist_pivot.global_transform.origin = twist_pivot.global_transform.origin.lerp(smooth_target_pos, camera_smoothing_rate)
	pitch_input += -cam_dir.y * joystick_sensitivity

	#För att rotera karaktären längs riktningen hen går i
	var player_rotation = atan2(direction.x, direction.z) # i radian, rotation angle
	#Camera rotations
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	#Smoothing of camera
	pitch_pivot.rotation.x = lerp_angle(clamp(pitch_pivot.rotation.x, -0.5, deg_to_rad(30)), rotation.x, 0.1)
	twist_pivot.rotation.z = lerp_angle(clamp(twist_pivot.rotation.z, -0.5, deg_to_rad(30)), rotation.z, 0.1)
	twist_input = lerp(twist_pivot.rotation.x, 0.0, 0.1)
	pitch_input = lerp(pitch_pivot.rotation.z, 0.0, 0.1)

	#Player acceleration
	if direction != Vector3.ZERO:
		if player_velocity.length() > 2.8 and is_on_floor():
			state_machine.travel("Running")
		player_velocity = player_velocity.lerp(direction*SPEED, ACCELERATION*delta)
		model.rotation.y = lerp_angle(model.rotation.y, player_rotation, delta * 5.0)

	#Player deacceleration
	else:
		if player_velocity.length() <= 2.8 and is_on_floor():
			state_machine.travel("Idle")
		player_velocity = player_velocity.lerp(Vector3.ZERO, DEACCELERATION*delta)
		velocity.x = move_toward(velocity.x, 0, SPEED*DEACCELERATION)
		velocity.z = move_toward(velocity.z, 0, SPEED*DEACCELERATION)

	velocity.x = player_velocity.x # update final value
	velocity.z = player_velocity.z
	# Jumping
	velocity.y = jump_state_adv

	# Reset capture when closing
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	if last_floor:
		lastSavePosition = global_transform.origin # for respawn
	floor_snap_length=0.05
	apply_floor_snap()
	move_and_slide() # rörelse enligt velocity mm.
	apply_push_to_other_players() # används för att sköta collisions
	for body in recently_pushed.keys():
		recently_pushed[body] -= delta
	for body in recently_pushed.keys():
		if recently_pushed[body] <= 0:
			recently_pushed.erase(body)


	if Input.is_action_just_pressed("use_item_%s" % [player_id]):
		state_machine.travel("Throw")
		update_item_label(" ")

	if Input.is_action_just_pressed("use_item_up_%s" % [player_id]):
		var play = get_tree().root.get_node("Game/GridContainer/SubViewportContainer/SubViewport/Player") as CharacterBody3D
		throwItem(play)
	if Input.is_action_just_pressed("use_item_right_%s" % [player_id]):
		var play = get_tree().root.get_node("Game/GridContainer/SubViewportContainer2/SubViewport/Player2") as CharacterBody3D
		throwItem(play)
	if Input.is_action_just_pressed("use_item_down_%s" % [player_id]):
		var play = get_tree().root.get_node("Game/GridContainer/SubViewportContainer3/SubViewport/Player3") as CharacterBody3D
		throwItem(play)
	if Input.is_action_just_pressed("use_item_left_%s" % [player_id]):
		var play = get_tree().root.get_node("Game/GridContainer/SubViewportContainer4/SubViewport/Player4") as CharacterBody3D
		throwItem(play)

#hanterar jump logic, will adjust with button press sensitivity
func player_jump_adv(jump_velocity,last_floor,is_coyote, delta) -> float:
	var is_jumping = Input.is_action_just_pressed("jump_%s" % [player_id]) and is_on_floor()
	var is_releasing_jump = Input.is_action_just_released("jump_%s" % [player_id]) and jump_velocity > 0

	if !is_on_floor() and (!is_jumping or !is_releasing_jump):
		is_coyote = true
		coyote_timer.start()
	if is_jumping and ( last_floor or is_coyote):

		jump_velocity += JUMP_VELOCITY
	elif not is_on_floor():
		if is_releasing_jump and jump_velocity > 0:
			jump_velocity -= GRAVITY * JUMPDEACCELERATION * delta * FALLMULTIPLIER
		else:
			jump_velocity += GRAVITY * JUMPACCELERATION * delta * JUMPCUTMULTIPLIER
	if jump_velocity>0.0:
		state_machine.travel("Jumping")
	return jump_velocity


func apply_push_to_other_players() -> void:
	var collisions_amount = get_slide_collision_count()

	for i in range(collisions_amount):
		var collision = get_slide_collision(i)
		var Collision_object = collision.get_collider()

		if Collision_object is CharacterBody3D and Collision_object != self:
			if Collision_object in recently_pushed:
				continue # already pushed recently

			var push_normal = - collision.get_normal()

			var relative_speed = velocity.length()
			var push_strength = relative_speed * PUSH_FORCE
			var push_force = (push_normal * push_strength).normalized() * PUSH_FORCE

			Collision_object.velocity.x += push_force.x
			Collision_object.velocity.z += push_force.z
			recently_pushed[Collision_object] = PUSH_COOLDOWN


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			twist_input = - event.relative.x * mouse_sensitivity
			pitch_input = - event.relative.y * mouse_sensitivity

func _on_area_3d_visibility_changed() -> void:
	pass # Replace with function body.

func _on_coyote_timer_timeout():
	is_coyote = false

#--respawning, called from Kill-zone Scene script when falling into water
func respawn():
	state_machine.travel("Drowning")
	respawn_manager.respawn()


func setItem(item: Item):
	if holdingItem != null:
		holdingItem.queue_free()
		await holdingItem.tree_exited
	holdingItem = item
	update_icon(holdingItem.icon)
	update_item_label(holdingItem.labelText)

func throwItem(play: CharacterBody3D = null):
	if holdingItem == null:
		return
	if play == null:
		holdingItem.throw()
	else:
		holdingItem.throw(play)
	holdingItem = null
	update_icon(null)
	update_item_label("")
