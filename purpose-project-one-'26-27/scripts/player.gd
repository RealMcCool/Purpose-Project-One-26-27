class_name Player extends CharacterBody3D

@export var walk_speed := 5.0
@export var dash_speed := 8.0
@export var jump_velocity := 6.0
var last_velocity := Vector3.ZERO
var max_camera_angle := 80.0
var mouse_sensitivity := 0.001
var can_dash := true
@export var max_dashes := 1
var dashes_left := max_dashes


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	movement_inputs(delta)
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		%CameraPivot.rotation.x += -Input.get_last_mouse_velocity().y * mouse_sensitivity
		if %CameraPivot.rotation_degrees.x <= -max_camera_angle:
			%CameraPivot.rotation_degrees.x = -max_camera_angle
		elif %CameraPivot.rotation_degrees.x >= max_camera_angle:
			%CameraPivot.rotation_degrees.x = max_camera_angle
		self.rotation.y += -Input.get_last_mouse_velocity().x * mouse_sensitivity
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif Input.is_action_just_pressed("ui_select"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func movement_inputs(delta: float) -> void:
	var movement_vector = Input.get_vector("left", "right", "forward", "backward").normalized()
	movement_vector = movement_vector.rotated(-self.rotation.y)
	velocity = Vector3(last_velocity.x, 0, last_velocity.z)
	
	if dashes_left == max_dashes:
		velocity = velocity.move_toward(Vector3.ZERO,walk_speed) # Multiply by delta for better deceleration?
		velocity += Vector3(movement_vector.x, 0, movement_vector.y)*walk_speed
		#if is_on_floor() and movement_vector == Vector2.ZERO:
			#velocity = Vector3.ZERO
		velocity = velocity.limit_length(walk_speed)
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
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	if is_on_ceiling() or velocity.y == 0:
		velocity.y = get_gravity().y*delta


func dash(_delta: float) -> void:
	if Input.is_action_just_pressed("dash") and not is_on_floor() and dashes_left >= 1:
		dashes_left -= 1
		var dash_velocity := get_direction_vector()*dash_speed
		velocity.x = dash_velocity.x
		velocity.z = dash_velocity.z
		velocity.y = dash_velocity.y


func get_direction_vector(include_y := true) -> Vector3:
	var direction := Vector3(0,0,-1)
	if include_y:
		direction = direction.rotated(Vector3(1,0,0),%CameraPivot.rotation.x)
	direction = direction.rotated(Vector3(0,1,0),self.rotation.y)
	return direction.normalized()
