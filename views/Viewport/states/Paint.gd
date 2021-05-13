extends Node

onready var cam = $"../spatial/camroot/cam"
onready var textures = $"../spatial/textures"

func update(delta):
	# Get mouse pos in ndc space
	var vp = get_viewport()
	var mouse_pos = vp.get_mouse_position() / vp.size
	
	# Aspect ratio correction
	mouse_pos.x -= 0.5
	mouse_pos.x *= vp.size.x / float(vp.size.y)
	mouse_pos.x += 0.5
	
	# Hack to prevent painting being stuck
	if !Input.is_mouse_button_pressed(BUTTON_LEFT) && !Input.is_mouse_button_pressed(BUTTON_RIGHT):
		textures.should_paint = false

	# Update paint shaders
	textures.update_shaders(mouse_pos, 4, cam, Color(1.0, 1.0, 1.0, 1.0))

func handle_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			textures.should_paint = true
			textures.should_paint_decal = event.button_index == BUTTON_RIGHT
		else:
			textures.should_paint = false
