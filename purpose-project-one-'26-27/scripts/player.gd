extends CharacterBody3D

@export var speed := 4.0
@export var jump_velocity := 5
var last_velocity : Vector3
var max_camera_angle := 80
var mouse_sensitivity := 0.001

func _physics_process(delta: float) -> void:
	movement_inputs(delta)
	%CameraPivot.rotation.x += -Input.get_last_mouse_velocity().y * mouse_sensitivity
	if %CameraPivot.rotation_degrees.x <= -max_camera_angle:
		%CameraPivot.rotation_degrees.x = -max_camera_angle
	elif %CameraPivot.rotation_degrees.x >= max_camera_angle:
		%CameraPivot.rotation_degrees.x = max_camera_angle
	self.rotation.y += -Input.get_last_mouse_velocity().x * mouse_sensitivity
	#%CameraPivot.rotation.z = 0

func movement_inputs(delta: float) -> void:
	var movement_vector = Input.get_vector("left", "right", "forward", "backward").normalized()
	movement_vector = movement_vector.rotated(-self.rotation.y)
	velocity = Vector3(movement_vector.x, 0, movement_vector.y)*speed
	jump(delta)
	last_velocity = velocity
	move_and_slide()

func jump(delta: float) -> void:
	if not is_on_floor():
		velocity.y = last_velocity.y + get_gravity().y*delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	if is_on_ceiling() or velocity.y == 0:
		velocity.y = get_gravity().y*delta
