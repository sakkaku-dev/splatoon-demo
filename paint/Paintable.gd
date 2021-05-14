extends Spatial

export var mesh_path: NodePath
onready var mesh = get_node(mesh)

onready var textures := $textures

func _ready():
	textures.set_texture_for_mesh(mesh)
