extends RigidBody3D

@export var speed = 1000
@export var direction := Vector3.DOWN:
	set(v):
		direction = v 
		apply_force_custom(v)

@onready var spring_arm := $SpringArm
@onready var camera := $SpringArm/Camera

var velocity = Vector3.ZERO

func apply_force_custom(dir: Vector3) -> void:
	apply_central_impulse(dir.normalized() * speed)

#func _physics_process(delta):
#	velocity = direction * speed * delta
#	velocity.y -= gravity * delta
#	global_transform.origin += velocity


func _on_LifeTimer_timeout():
	queue_free()


func _on_PaintBall_body_entered(body):
	
	if not body.has_method("get_textures"):
		queue_free()
		return
	
	var texture: Textures = body.get_textures()
	var orth = direction.rotated(Vector3.RIGHT, deg_to_rad(90))
	
	spring_arm.look_at(direction, orth)
	
	var pos = camera.unproject_position(global_transform.origin) / get_viewport().size
	var paint_layer = texture.get_paint_layer(Textures.Slot.ALBEDO)
	paint_layer.do_paint(pos, 4, camera, Color(1.0, 1.0, 1.0, 1.0), body.global_transform.origin)

	queue_free()


func _on_Area_body_entered(body):
	_on_PaintBall_body_entered(body)
