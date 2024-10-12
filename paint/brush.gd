class_name Brush
extends Node2D

@export var texture: Texture2D
@export var brush_size := 100
@export var uv_position: UVPosition
@export var texture_size := 1024
@export var score_calc: ScoreCalculator

var brush_queue := []

func paint(pos: Vector3, normal: Vector3, color: Color):
	var uv = uv_position.get_uv_coords(pos, normal, true)
	if uv:
		brush_queue.push_back([uv * texture_size, color])
		queue_redraw()

func _draw() -> void:
	for b in brush_queue:
		draw_texture_rect(texture, Rect2(b[0].x - brush_size/2, b[0].y - brush_size / 2, brush_size, brush_size), false, b[1])
	
	brush_queue = []
	score_calc.recalculate_score()
