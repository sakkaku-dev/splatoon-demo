extends Node3D

@export var bullet_scene: PackedScene
@export var fire_rate = 1.0

@onready var fire_rate_timer := $FireRateTimer

var can_shoot = true

func fire(target: Vector3):
	if not can_shoot: return
	
	can_shoot = false
	var bullet: Node3D = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_transform = global_transform
	bullet.direction = target - global_transform.origin
	
	fire_rate_timer.start(fire_rate)


func _on_FireRateTimer_timeout():
	can_shoot = true
