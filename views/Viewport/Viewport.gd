extends WorldEnvironment

onready var parent_viewport = get_parent()
onready var camera =  $spatial/camroot/cam
onready var mesh_instance = $spatial/mesh
onready var paint = $Paint

func _process(delta):
	paint.update(delta)


func _unhandled_input(event):
	paint.handle_input(event)


func _ready():
	# setup the mesh's spatial textures (TODO maybe do this in the Textures node instead?)
	var mat = mesh_instance.get_surface_material(0)
	mat.albedo_texture = Textures.get_node("paint/albedo").get_texture()
	mat.roughness_texture = Textures.get_node("paint/roughness").get_texture()
	mat.metallic_texture = Textures.get_node("paint/metalness").get_texture()
	mat.emission_texture = Textures.get_node("paint/emission").get_texture()
#	$debug_todo_remove_this.texture =  Textures.get_node("depth_buffer").get_texture()
	
	# setup the paint shader's viewport textures
	var paint_shader = preload("res://assets/shaders/paint_shader.tres") 
	paint_shader.set_shader_param("meshtex_pos", Textures.get_node("mesh/position").get_texture())
	paint_shader.set_shader_param("meshtex_normal",  Textures.get_node("mesh/normal").get_texture())
	paint_shader.set_shader_param("depth_tex", Textures.get_node("depth_buffer").get_texture())
	
	# finally setup mesh
	change_mesh(preload("res://assets/models/Suzanne.mesh"))


func change_mesh(mesh): # This will make the program paint on a different mesh
	
	var mat = mesh_instance.get_surface_material(0)
	mesh_instance.mesh = mesh

	# Set all the viewports to Filter + Aniso so we get smooth jaggies (This needs to be done here, since it seems not to work when set in the editor)
	var flags = Texture.FLAG_FILTER | Texture.FLAG_ANISOTROPIC_FILTER
	mat.albedo_texture.flags = flags 
	mat.roughness_texture.flags = flags
	mat.metallic_texture.flags = flags
	mat.emission_texture.flags = flags
	
	mesh_instance.set_surface_material(0, mat)
	
	# Regenerate all the mesh textures
	for vp in Textures.get_node("mesh").get_children():
		vp.mesh = mesh
		vp.regenerate_mesh_texture()

