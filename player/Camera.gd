extends Spatial

export var camera_length = 7
export var camera_zoom_speed = 7

export(float, 0.1, 1) var mouse_sensitivity = .2
export(float, -90, 0) var min_pitch = -80
export(float, 0, 90) var max_pitch = 80

onready var camera_base = $"."
onready var camera_rot = $CameraRot
onready var camera_spring = $CameraRot/SpringArm

var camera_x_rot = 0.0
var spring_length = 0

func _ready():
	spring_length = camera_length
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		camera_base.rotation_degrees.y -= event.relative.x * mouse_sensitivity
		camera_rot.rotation_degrees.x -= event.relative.y * mouse_sensitivity
		camera_rot.rotation_degrees.x = clamp(camera_rot.rotation_degrees.x, min_pitch, max_pitch)
	
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
