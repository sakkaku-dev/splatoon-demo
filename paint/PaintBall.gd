extends Area

export var speed = 1.0
export var direction = Vector3.DOWN

onready var spring_arm := $SpringArm
onready var camera := $SpringArm/Camera

func _physics_process(delta):
	global_transform.origin += direction * delta * speed


func _on_PaintBall_body_entered(body: Spatial):
	if not body.has_method("get_texture"): return
	
	var texture: Textures = body.get_texture()
	var orth = direction.rotated(Vector3.RIGHT, deg2rad(90))
	
	spring_arm.look_at(direction, orth)
	
	var pos = camera.unproject_position(global_transform.origin) / get_viewport().size
	var paint_layer = texture.get_paint_layer(Textures.Slot.ALBEDO)
	paint_layer.do_paint(pos, 4, camera, Color(1.0, 1.0, 1.0, 1.0), body.global_transform.origin)

	queue_free()
