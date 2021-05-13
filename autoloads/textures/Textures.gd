extends Node

var should_paint = false
var should_paint_decal = false

onready var albedo = $paint/albedo
onready var roughness = $paint/roughness
onready var metallic = $paint/metalness
onready var emission = $paint/emission

onready var meshes = $mesh
onready var mesh_position = $mesh/position
onready var mesh_normal = $mesh/normal
onready var depth_buffer = $depth_buffer

enum Slot {
	ALBEDO,
	ROUGHNESS,
	METALNESS,
	EMISSION
}

# Which slot we are currently painting on
var current_slot = Slot.ALBEDO

func set_texture_for_mesh(mesh: MeshInstance):
	var mat = mesh.get_surface_material(0)
	mat.albedo_texture = albedo.get_texture()
	mat.roughness_texture = roughness.get_texture()
	mat.metallic_texture = metallic.get_texture()
	mat.emission_texture = emission.get_texture()
	
	# setup the paint shader's viewport textures
	var paint_shader = preload("res://assets/shaders/paint_shader.tres") 
	paint_shader.set_shader_param("meshtex_pos", mesh_position.get_texture())
	paint_shader.set_shader_param("meshtex_normal",  mesh_normal.get_texture())
	paint_shader.set_shader_param("depth_tex", depth_buffer.get_texture())
	
	var flags = Texture.FLAG_FILTER | Texture.FLAG_ANISOTROPIC_FILTER
	mat.albedo_texture.flags = flags 
	mat.roughness_texture.flags = flags
	mat.metallic_texture.flags = flags
	mat.emission_texture.flags = flags
	
	# Regenerate all the mesh textures
	for vp in meshes.get_children():
		vp.mesh = mesh.mesh
		vp.regenerate_mesh_texture()

#func _process(delta):
#	update_depth_buffer()
#
#func update_depth_buffer(): 
#
#	# update depth buffer size to match parent viewport
#	var parent_viewport = PainterState.main.get_parent()
#	depth_buffer.size = parent_viewport.size
#
#	var camera =  PainterState.main.camera
#
#	# update the camera slave to match the actual camera
#	var camera_slave = Textures.get_node("depth_buffer/cam_slave")
#	camera_slave.global_transform = camera.global_transform
#	camera_slave.fov = camera.fov
#	camera_slave.near = camera.near
#	camera_slave.far = camera.far
#
#	# set depth_quad distance to camera to average of znear and zfar
#	# this prevents the depth quad disappearing due to falling outside the depth buffer range
#	camera_slave.get_node("depth_quad").translation.z = (camera.near + camera.far) / -2.0
	
	# this forces a viewport redraw
	# TODO new viewport is slow since it's drawing the object TWICE, once in main buffer and once in depth buffer.
	# only update the viewport when camera transform/fov/near/far changes
	# depth_buffer.render_target_update_mode = Viewport.UPDATE_ONCE
	# Update - new bug appeared! when viewport is thin and you change znear, the viewport doesn't clear itself anymore
	# UPDATE2 - even after uncommenting this, the viewport still occasionally ends up in no-clear mode
	
func update_shaders(mouse_pos, size, cam, color):
	
#	var parent_viewport = PainterState.main.get_parent()
	
	
	var cam_matrix = cam.global_transform
	
	for paint_sprite in get_tree().get_nodes_in_group("paint_sprite"):
		
		var mat = paint_sprite.material
		
		var paint_sprite_name = paint_sprite.get_parent().name 
		var slot_matches = Slot[paint_sprite_name.to_upper()] == current_slot
		paint_sprite.visible = should_paint && slot_matches
		
		# var label = get_node("/root/main/ui/hbox/" + paint_sprite_name + "/label")
		# label.add_color_override("font_color", Color(1,0.3,0) if slot_matches else Color(1,1,1))
		
		if !paint_sprite.visible:
			continue

		mat.set_shader_param("scale", size)
		mat.set_shader_param("cam_mat", cam_matrix)
		mat.set_shader_param("z_near", cam.near)
		mat.set_shader_param("z_far", cam.far)
		mat.set_shader_param("fovy_degrees", cam.fov)
		mat.set_shader_param("mouse_pos", mouse_pos)
		mat.set_shader_param("aspect", 1.0) # Don't change this or your brush gets skewed!
		mat.set_shader_param("aspect_shadow", 1.0) #float(parent_viewport.size.x) / parent_viewport.size.y)
		mat.set_shader_param("decal", should_paint_decal)
		mat.set_shader_param("color", color)
	
