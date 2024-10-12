class_name CrosshairLines
extends Control

@export var color := Color.WHITE:
	set(v):
		if v == color: return
		
		color = v
		for l in lines:
			l.default_color = color
		queue_redraw()

@export var dot_size := 1.0

@export_category("Lines")
@export var line_length := 10.0
@export var line_width := 1.0
@export var line_distance := 10.0

@export_category("Animation")
@export var line_move_speed := 0.25
@export var line_move_distance := 1.0

@onready var top: Line2D = $Top
@onready var left: Line2D = $Left
@onready var bot: Line2D = $Bot
@onready var right: Line2D = $Right
@onready var lines: Array[Line2D] = [top, left, bot, right]

@onready var line_dirs = {
	top.name: Vector2.UP,
	left.name: Vector2.LEFT,
	right.name: Vector2.RIGHT,
	bot.name: Vector2.DOWN,
}

func _ready() -> void:
	_set_lines()
	queue_redraw()

func _set_lines():
	for line in lines:
		var dir = line_dirs[line.name]
		line.width = line_width
		line.points = [Vector2.ZERO, dir * line_length]

func _set_line_distance(dist: float):
	for line in lines:
		var dir = line_dirs[line.name]
		line.position = lerp(line.position, dir * dist, line_move_speed)

func update_distance(dist: float = 0.0):
	_set_line_distance(line_distance + dist * line_move_distance)

func _draw() -> void:
	draw_circle(Vector2(0, 0), dot_size, color)
