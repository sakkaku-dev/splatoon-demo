extends Node3D

class_name PlayerCamera

@export var camera_length = 7
@export var camera_zoom_speed = 7

@export_range(0.1, 1) var mouse_sensitivity = .2
@export_range(-90, 0) var min_pitch = -80
@export_range(0, 90) var max_pitch = 80

@export var max_zoom = 30
@export var min_zoom = 5

@onready var camera_base := $"."
@onready var camera_rot := $CameraRot
@onready var camera_spring := $CameraRot/SpringArm
@onready var camera := $CameraRot/SpringArm/Camera

var camera_x_rot = 0.0
var spring_length = 0

func _ready():
	spring_length = camera_length
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			camera_base.rotation_degrees.y -= event.relative.x * mouse_sensitivity
			camera_rot.rotation_degrees.x -= event.relative.y * mouse_sensitivity
			camera_rot.rotation_degrees.x = clamp(camera_rot.rotation_degrees.x, min_pitch, max_pitch)
		elif event is InputEventMouseButton:
			if event.is_pressed():
				if event.button_index == MOUSE_BUTTON_WHEEL_UP:
					spring_length = max(spring_length - 1, min_zoom)
				elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
					spring_length = min(spring_length + 1, max_zoom)
		elif event.is_action_pressed("ui_cancel"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _process(delta):
	_adjust_spring_length(delta)
	
func _adjust_spring_length(delta):
	var curr_length = camera_spring.get_length()
	var diff_length = spring_length - curr_length
	
	# it will never be exactly the same length
	if abs(diff_length) > 0.001:
		var change_length = curr_length + (diff_length * camera_zoom_speed * delta)
		camera_spring.set_length(change_length);

func target_direction_for_motion(motion: Vector2):
	var camera_basis = camera_rot.global_transform.basis
	var camera_x = _normalized_basis(camera_basis.x)
	var camera_z = _normalized_basis(camera_basis.z)
	
	return camera_x * motion.x + camera_z * motion.y

func _normalized_basis(basis):
	basis.y = 0
	return basis.normalized()

func get_center_position() -> Vector3:
	var rect = get_viewport().get_visible_rect()
	var center = camera.project_position(rect.size / 2, camera_spring.get_hit_length() * 10)
	
	return center
