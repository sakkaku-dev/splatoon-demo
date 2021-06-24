extends KinematicBody

export var speed = 10
export var acceleration = 700
export var friction = 1600
export var rotation_interpolate_speed = 10
export var jump_force = 20
export var max_terminal_velocity = 54

export var camera_path: NodePath
onready var camera = get_node(camera_path)

onready var textures: Textures = $Textures
onready var input := $PlayerInput
onready var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * ProjectSettings.get_setting("physics/3d/default_gravity_vector")

var motion = Vector2.ZERO
var velocity = Vector3.ZERO
var y_velocity = 0.0
var orientation = Transform()

func get_textures() -> Textures:
	return textures

func _unhandled_input(event):
	input.handle_input(event)


func _physics_process(delta):
	motion = _get_move_vector(input)
	_update_velocity(delta)
	

func _get_move_vector(input: InputReader) -> Vector2:
	return Vector2(
		input.get_action_strength("move_right") - input.get_action_strength("move_left"),
		input.get_action_strength("move_back") - input.get_action_strength("move_forward")
	)


func _update_velocity(delta):
	var target = camera.target_direction_for_motion(motion)
	if target.length() > 0.01:
		_rotate_to_target(target, delta)
	
	var is_moving = target.length() > 0.01
	var accel = acceleration if is_moving else friction
	
	velocity = velocity.move_toward(target * speed, accel * delta)
	
	if is_on_floor():
		y_velocity = -0.01
	else:
		y_velocity = clamp(y_velocity - gravity.y, -max_terminal_velocity, max_terminal_velocity)

	if input.is_just_pressed("jump") and is_on_floor():
		y_velocity = jump_force
	
	velocity.y = y_velocity
	velocity = move_and_slide(velocity, Vector3.UP)

	orientation.origin = Vector3()
	orientation = orientation.orthonormalized()
	global_transform.basis = orientation.basis


func _rotate_to_target(target, delta):
	_rotate_to(Transform().looking_at(-target, Vector3.UP), delta)


func _rotate_to(to, delta):
	var q_from = orientation.basis.get_rotation_quat()
	var q_to = to.basis.get_rotation_quat()
	orientation.basis = Basis(q_from.slerp(q_to, delta * rotation_interpolate_speed))

