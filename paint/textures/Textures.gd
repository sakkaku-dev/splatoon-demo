extends Node

class_name Textures

var should_paint = false

export var mesh_path: NodePath
onready var mesh_instance := get_node(mesh_path)

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


func _ready():
	set_texture_for_mesh(mesh_instance)


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


func get_paint_layer(slot: int) -> MaterialTexture:
	match slot:
		Slot.ALBEDO: return albedo
		Slot.ROUGHNESS: return roughness
		Slot.METALNESS: return metallic
		Slot.EMISSION: return emission
	return null
