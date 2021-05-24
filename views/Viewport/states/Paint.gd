extends Node

export var cam_path: NodePath
onready var cam: Camera = get_node(cam_path)

export var textures_path: NodePath
onready var textures = get_node(textures_path)

export var mesh_path: NodePath
onready var mesh: Spatial = get_node(mesh_path)

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
	if textures.should_paint:
		textures.get_paint_layer(Textures.Slot.ALBEDO).do_paint(mouse_pos, 4, cam, Color(1.0, 1.0, 1.0, 1.0), mesh.global_transform.origin)

func handle_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			textures.should_paint = true
		else:
			textures.should_paint = false
