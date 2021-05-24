extends WorldEnvironment

onready var paint = $Paint

func _process(delta):
	paint.update(delta)


func _unhandled_input(event):
	paint.handle_input(event)
