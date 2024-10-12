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

	if get_slide_collision_count() > 0:
		for i in range(0, get_slide_collision_count()):
			var col = get_slide_collision(i)
			brush.paint(col.get_position(), col.get_normal(), color)
		
		queue_free()
