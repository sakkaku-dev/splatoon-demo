extends CharacterBody3D

@export var speed = 5.0
@export var color := Color.RED

@onready var mesh_instance: MeshInstance3D = $MeshInstance

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var brush: Brush

func _ready() -> void:
	mesh_instance.material_override = mesh_instance.material_override.duplicate()
	var mat = mesh_instance.material_override as StandardMaterial3D
	mat.albedo_color = color

func set_start_velocity():
	velocity = (basis * Vector3.FORWARD).normalized() * speed
	
func _physics_process(delta: float) -> void:
	velocity.y -= gravity * delta
	look_at(position + velocity)
	
	move_and_slide()	
	
	# Previous version used a camera, might still be needed in the future
	#if not body.has_method("get_textures"):
		#queue_free()
		#return
	#
	#var texture: Textures = body.get_textures()
	#var orth = direction.rotated(Vector3.RIGHT, deg_to_rad(90))
	#spring_arm.look_at(direction, orth)
	
	#var pos = camera.unproject_position(global_transform.origin) / get_viewport().size
	#var paint_layer = texture.get_paint_layer(Textures.Slot.ALBEDO)
	#paint_layer.do_paint(pos, 4, camera, Color(1.0, 1.0, 1.0, 1.0), body.global_transform.origin)
	#queue_free()

	if get_slide_collision_count() > 0:
		for i in range(0, get_slide_collision_count()):
			var col = get_slide_collision(i)
			brush.paint(col.get_position(), col.get_normal(), color)
		
		queue_free()
