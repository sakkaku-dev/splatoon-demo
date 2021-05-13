extends WorldEnvironment

onready var mesh_instance = $spatial/mesh
onready var paint = $Paint
onready var textures = $spatial/textures

func _process(delta):
	paint.update(delta)


func _unhandled_input(event):
	paint.handle_input(event)


func _ready():
	textures.set_texture_for_mesh(mesh_instance)
