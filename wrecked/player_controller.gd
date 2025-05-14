extends CharacterBody3D

const SPEED = 9
const GRAVITY = -9.8
const JUMP_VELOCITY = 9.5
const JUMPACCELERATION = 2.5
const JUMPDEACCELERATION = 8.5
const PUSH_FORCE = 15.8
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
var last_platform = CollisionObject3D
@onready var model = Node3D
@onready var animation_player = AnimationPlayer
@onready var animation_tree := $AnimationTree
@onready var twist_pivot = $TwistPivot
@onready var Debug_label = $Debub_label
@onready var pitch_pivot = $TwistPivot/PitchPivot
@onready var currItem_node = $MarginContainer/CurrItemLabel
@onready var lastSavePosition: Vector3 = global_transform.origin
@onready var respawn_manager = $RespawnManager
@onready var label: Label = get_node("/root/Game/GameManager/CanvasLayer/SharedLabel")
@onready var label_node: Label = $MarginContainer/CurrItemLabel
@onready var icon_node: TextureRect = $IconTexture
@onready var swim_platform: CollisionShape3D = 	$SwimPlatform/CollisionShape3D

@onready var Camera = $TwistPivot/PitchPivot/Camera3D
@export var player_id = 1 # p1 är default val! Ändra per spelar node i inspector!var fall_multiplier: float = 0.5var jump_cut_multiplier: float = 0.8
@export var player_data: PlayerData
@export var camera_smoothing_rate = 0.1
#used to spawn correct character mesh
var player_names = {1:"Rackham_red",2:"Yates_yellow",3:"Gully_green",4:"Pippi_pink" }
#variables jump buffer
var jump_buffered := false
var jump_buffer_time := 1.8
var jump_buffer_timer := 0.0

#How long can you coyote
var coyote_time := 30.3
var coyote_timer := 0.0
# states
enum {IDLE, RUN,DROWNING}
var current_anim = IDLE



var holdingItem: Item
var last_saved_platform: Node3D
var viewPortTexture: Texture2D


func handle_anim_states():
	match current_anim:
		IDLE:
			animation_tree.set("parameters/Transition/transition_request","Idling")
		RUN:
			animation_tree.set("parameters/Transition/transition_request","Running")			
		DROWNING:
			animation_tree.set("parameters/Transition/transition_request","Drowning")
		


func _ready():
	var name = player_names.get(player_id)
	model = get_node(name)
	animation_player = str(name) + "/AnimationPlayer"
	animation_tree = $AnimationTree
	animation_tree.active = true
	await get_tree().process_frame
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	currItem_node.text = "Item: "
	currItem_node.modulate = player_data.color

	var shaderNode = get_parent().get_parent().get_node("ShaderTexture")
	var subViewport = get_parent().get_parent().get_node("SubViewport")
	shaderNode.custom_minimum_size = subViewport.size
	shaderNode.expand = true
	viewPortTexture = get_parent().get_parent().get_node("ShaderTexture").texture

	swim_platform.disabled = true

#call this func when you pick up/use some item
func update_item_label(item: String) -> void:
	if label_node: # avoid crashes if node is removed/changed
		label_node.text = "Player %s" % [player_id] + " Item: %s" % [item]

func update_icon(icon: Texture2D):
	if icon_node: # avoid crashes if node is removed/changed
		icon_node.texture = icon

#_physics då det är en Characterbody3d, kallas kontinuerligt.
func _physics_process(delta: float) -> void:
	handle_anim_states()

	var last_floor = is_on_floor()
	#make the character snap more
	floor_snap_length = 0.05

	if player_data == null:
		return  # Skip until player_data is set

	#Inputs
	var cam_dir = Input.get_vector("camera_move_right_%s" % [player_id], "camera_move_left_%s" % [player_id], "camera_move_down_%s" % [player_id], "camera_move_up_%s" % [player_id]) # normalized [-1,1] 2d vector
	var input_dir := Vector2.ZERO
	input_dir = Input.get_vector("move_left_%s" % [player_id], "move_right_%s" % [player_id], "move_forward_%s" % [player_id], "move_back_%s" % [player_id]) # vec2 (x(L/R) och zdir(forw/backw))
	#Player variables
	var player_position = position
	var player_velocity = velocity
	var jump_state_adv = player_jump_adv(player_velocity.y, delta)
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
	var jump_pressed = Input.is_action_just_pressed("jump_%s" % [player_id])

	#Player acceleration
	if jump_pressed and is_on_floor():
		animation_tree.set("parameters/Jumping/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	if direction != Vector3.ZERO:
		if player_velocity.length() > 2.8 and is_on_floor():
			current_anim = RUN
		player_velocity = player_velocity.lerp(direction*SPEED, ACCELERATION*delta)
		model.rotation.y = lerp_angle(model.rotation.y, player_rotation, delta * 5.0)
	#Player deacceleration
	else:
		if player_velocity.length() <= 2.5 and is_on_floor():
			if !jump_pressed:
				current_anim = IDLE
		player_velocity = player_velocity.lerp(Vector3.ZERO, DEACCELERATION*delta)
		velocity.x = move_toward(velocity.x, 0, SPEED*DEACCELERATION)
		velocity.z = move_toward(velocity.z, 0, SPEED*DEACCELERATION)

	velocity.x = player_velocity.x # update final value
	velocity.z = player_velocity.z
	velocity.y = jump_state_adv

	if player_position.y <-5.0:
		current_anim = DROWNING

	# Reset capture when closing
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

		
	if is_on_floor():
		var collision = get_slide_collision(0)
		if collision:
			var floor_object = collision.get_collider()
			if floor_object is not CharacterBody3D:
				last_saved_platform = floor_object
	

	apply_floor_snap()
	move_and_slide() # rörelse enligt velocity mm.
	apply_push_to_other_players() # används för att sköta collisions
	for body in recently_pushed.keys():
		recently_pushed[body] -= delta
	for body in recently_pushed.keys():
		if recently_pushed[body] <= 0:
			recently_pushed.erase(body)

	if Input.is_action_just_pressed("use_item_%s" % [player_id]):
		animation_tree.set("parameters/Useitem/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
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

	if holdingItem != null:
		holdingItem.global_position = global_position + Vector3(0, 2.3, 0)
		holdingItem.rotation.y = model.rotation.y
	
	# for swimming movement:
		
	if(player_data.can_swim):
		# Get the current world positions
		var plat_pos = $SwimPlatform.global_position
		var player_pos = global_position
		print(player_data.can_jump)
		# Platform moves after player
		plat_pos.x = player_pos.x
		plat_pos.z = player_pos.z
		
		# Move both(!) toward the water surface Y = -1.0
		var surface_y := -1.1
		# thi formula kinda workds
		plat_pos.y = lerp(plat_pos.y, surface_y, delta * 1.0)
		$SwimPlatform.global_position = plat_pos
		# Lerp the player up at 3 units/sec to sit slightly above the platform
		player_pos.y = lerp(player_pos.y, surface_y+1 , delta * 2.0)
		global_position = player_pos
			


func _on_swim_timer_timeout() -> void:
	# this runs 1 second after the water‐enter event
	player_data.can_jump = true

	
#hanterar jump logic, will adjust with button press sensitivity
func player_jump_adv(jump_velocity: float, delta: float) -> float:
	var jump_pressed = Input.is_action_just_pressed("jump_%s" % [player_id])
	var jump_released = Input.is_action_just_released("jump_%s" % [player_id]) and jump_velocity > 0
	var jump_available = true

	if is_on_floor():
		jump_available= true
		coyote_timer = coyote_time
	else:
		coyote_timer -= delta
	if jump_available or coyote_time >0.0:
		if jump_pressed  and is_on_floor():
			jump_available = false
			jump_buffered = true
			jump_buffer_timer = jump_buffer_time
		if !is_on_floor():
			jump_available = false
		if jump_buffered:
			jump_buffer_timer -= delta
			if jump_buffer_timer <= 0.0:
				jump_buffered = false
		if jump_buffered and coyote_timer > 0.0:
			jump_velocity = JUMP_VELOCITY
			jump_buffered = false
		elif not is_on_floor():
			if jump_released:
				jump_velocity -= GRAVITY * JUMPDEACCELERATION * delta * FALLMULTIPLIER
			else:
				jump_velocity += GRAVITY * JUMPACCELERATION * delta * JUMPCUTMULTIPLIER
	return jump_velocity

func handle_jump_input(delta):
	if Input.is_action_just_pressed("jump_%s" % [player_id]):
		jump_buffered = true
		jump_buffer_timer = jump_buffer_time


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


#--respawning, called from Kill-zone Scene script when falling into water
func respawn():
	respawn_manager.respawn(player_data.placement)


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
		animation_tree.set("parameters/Useitem/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		holdingItem.throw(play)
	holdingItem = null
	update_icon(null)
	update_item_label("")
