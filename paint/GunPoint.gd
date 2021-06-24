extends Spatial

export var bullet_scene: PackedScene
export var fire_rate = 1.0

onready var fire_rate_timer := $FireRateTimer

var can_shoot = true

func _physics_process(delta):
	if Input.is_action_pressed("fire"):
		fire()

func fire():
	if not can_shoot: return
	
	can_shoot = false
	var bullet: Spatial = bullet_scene.instance()
	bullet.direction = Vector3.BACK
	get_tree().current_scene.add_child(bullet)
	bullet.global_transform = global_transform
	
	fire_rate_timer.start(fire_rate)


func _on_FireRateTimer_timeout():
	can_shoot = true
