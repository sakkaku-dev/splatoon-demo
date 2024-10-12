extends CharacterBody3D

@export var speed = 10
@export var acceleration = 700
@export var friction = 1600
@export var rotation_interpolate_speed = 10
@export var jump_force = 20
@export var max_terminal_velocity = 54

@export var color_1 := Color.RED
@export var color_2 := Color.BLUE

@export var camera_path: NodePath
@onready var camera = get_node(camera_path)

@onready var input := $PlayerInput
@onready var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * ProjectSettings.get_setting("physics/3d/default_gravity_vector")
@onready var paint_emitter: Node3D = $PaintEmitter

var motion = Vector2.ZERO
var y_velocity = 0.0
var orientation = Transform3D()

func _ready() -> void:
	input.just_pressed.connect(func(ev: InputEvent):
		if ev.is_action_pressed("jump") and is_on_floor():
			velocity.y = -jump_force
			
		if ev.is_action_pressed("color_1"):
			paint_emitter.color = color_1
		elif ev.is_action_pressed("color_2"):
			paint_emitter.color = color_2
	)
	
	paint_emitter.color = color_1

func _physics_process(delta):
	motion = _get_move_vector(input)
	_update_velocity(delta)
	
	#if input.is_pressed("fire"):
		#var center = camera.get_center_position()
		#var dir = Vector3(center.x, global_transform.origin.y, center.z)
		#look_at(dir, Vector3.UP)
		#orientation.basis = global_transform.basis
		#gun.fire(center)

	paint_emitter.emit = input.is_pressed("fire")

func _get_move_vector(input: InputReader) -> Vector2:
	return Vector2(
		input.get_action_strength("move_right") - input.get_action_strength("move_left"),
		input.get_action_strength("move_back") - input.get_action_strength("move_forward")
	)

func _get_target_motion_and_turn(motion: Vector2, delta: float) -> Vector3:
	var target = camera.target_direction_for_motion(motion)
	if target.length() > 0.01:
		_rotate_to_target(target, delta)
	return target

func _update_velocity(delta):
	var target = _get_target_motion_and_turn(motion, delta)
	var is_moving = target.length() > 0.01
	var accel = acceleration if is_moving else friction
	
	velocity = velocity.move_toward(target * speed, accel * delta)
	
	if is_on_floor():
		y_velocity = -0.01
	else:
		y_velocity = clamp(y_velocity + gravity.y, -max_terminal_velocity, max_terminal_velocity)
	
	velocity.y = y_velocity
	move_and_slide()

	orientation.origin = Vector3()
	orientation = orientation.orthonormalized()
	global_transform.basis = orientation.basis


func _rotate_to_target(target, delta):
	_rotate_to(Transform3D().looking_at(target, Vector3.UP), delta)


func _rotate_to(to, delta):
	var q_from = orientation.basis.get_rotation_quaternion()
	var q_to = to.basis.get_rotation_quaternion()
	orientation.basis = Basis(q_from.slerp(q_to, delta * rotation_interpolate_speed))
