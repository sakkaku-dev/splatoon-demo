extends Viewport

class_name MaterialTexture

export var enabled = false

onready var paint_sprite = $PaintSprite

func _ready():
	paint_sprite.visible = enabled

func set_mesh_values(mesh_position, mesh_normal):
	paint_sprite.material.set_shader_param("meshtex_pos", mesh_position.get_texture())
	paint_sprite.material.set_shader_param("meshtex_normal",  mesh_normal.get_texture())

func do_paint(mouse_pos, size, cam, color, offset):
	var cam_matrix = cam.global_transform
	var mat = paint_sprite.material
	
	mat.set_shader_param("scale", size)
	mat.set_shader_param("cam_mat", cam_matrix)
	mat.set_shader_param("z_near", cam.near)
	mat.set_shader_param("z_far", cam.far)
	mat.set_shader_param("fovy_degrees", cam.fov)
	mat.set_shader_param("mouse_pos", mouse_pos)
	mat.set_shader_param("aspect", 1.0) # Don't change this or your brush gets skewed!
	mat.set_shader_param("aspect_shadow", 1.0) #float(parent_viewport.size.x) / parent_viewport.size.y)
	#mat.set_shader_param("decal", should_paint_decal)
	mat.set_shader_param("color", color)
	mat.set_shader_param("pos_offset", offset)
