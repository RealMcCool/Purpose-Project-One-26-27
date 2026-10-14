class_name Player extends CharacterBody3D

@export var walk_speed := 6.0
@export var dash_speed := 10.0
@export var dash_adjust_speed := 0.25
@export var jump_velocity := 6.0
var last_velocity := Vector3.ZERO
var max_camera_angle := 80.0
var mouse_sensitivity := 0.055
var can_dash := true
@export var max_dashes := 1
var dashes_left := max_dashes
var dash_length : float
var dash_direction : Vector3
var can_move := true
@export var air_friction := false
#signal player_dashed


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	if can_move:
		movement_inputs(delta)
		mouse_inputs(delta)


func mouse_inputs(delta: float) -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		%CameraPivot.rotation.x += -Input.get_last_mouse_velocity().y * mouse_sensitivity * delta
		if %CameraPivot.rotation_degrees.x <= -max_camera_angle:
			%CameraPivot.rotation_degrees.x = -max_camera_angle
		elif %CameraPivot.rotation_degrees.x >= max_camera_angle:
			%CameraPivot.rotation_degrees.x = max_camera_angle
		self.rotation.y += -Input.get_last_mouse_velocity().x * mouse_sensitivity * delta
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif Input.is_action_just_pressed("ui_select"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func movement_inputs(delta: float) -> void:
	var movement_vector = Input.get_vector("left", "right", "forward", "backward").normalized()
	movement_vector = movement_vector.rotated(-self.rotation.y)
	velocity = Vector3(last_velocity.x, 0, last_velocity.z)
	
	#print(velocity.direction_to(Vector3.ZERO).sign(), " vs. ", dash_direction.sign())
	if dashes_left == max_dashes:
		velocity = velocity.move_toward(Vector3.ZERO,walk_speed) # Multiply by delta for better deceleration?
		velocity += Vector3(movement_vector.x, 0, movement_vector.y)*walk_speed
		#if is_on_floor() and movement_vector == Vector2.ZERO:
			#velocity = Vector3.ZERO
		velocity = velocity.limit_length(walk_speed)
	elif velocity.direction_to(Vector3.ZERO).sign() != dash_direction.sign():
		velocity += Vector3(movement_vector.x, 0, movement_vector.y)*dash_adjust_speed
		velocity = velocity.limit_length(dash_length) 
	
	
	
	if air_friction:
		velocity = velocity.move_toward(Vector3.ZERO,walk_speed*delta)
	
	if is_on_floor():
		dashes_left = max_dashes
	jump(delta)
	dash(delta)
	last_velocity = velocity
	move_and_slide()


func jump(delta: float) -> void:
	if not is_on_floor():
		velocity.y = last_velocity.y + get_gravity().y*delta
		if is_on_wall() and velocity.y < get_gravity().y:
			velocity.y = get_gravity().y
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	if is_on_ceiling() or velocity.y == 0:
		velocity.y = get_gravity().y*delta


func dash(_delta: float) -> void:
	if Input.is_action_just_pressed("dash") and (not get_direction_vector().y < 0 or not is_on_floor()) and dashes_left >= 1:
		dashes_left -= 1
		var dash_velocity := get_direction_vector()*dash_speed
		velocity.x = dash_velocity.x
		velocity.z = dash_velocity.z
		velocity.y = dash_velocity.y
		dash_direction = Vector3(dash_velocity.x, 0, dash_velocity.z).normalized()
		dash_length = Vector3(dash_velocity.x, 0, dash_velocity.z).length()
		#player_dashed.emit()


func get_direction_vector(include_y := true) -> Vector3:
	var direction := Vector3(0,0,-1)
	if include_y:
		direction = direction.rotated(Vector3(1,0,0),%CameraPivot.rotation.x)
	direction = direction.rotated(Vector3(0,1,0),self.rotation.y)
	return direction.normalized()


func reset_camera(look_angle := 0.0) -> void:
	%CameraPivot.rotation.x = 0
	self.rotation.y = look_angle
