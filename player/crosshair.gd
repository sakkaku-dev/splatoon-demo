class_name Crosshair
extends Control

@export var player: CharacterBody3D

@export var max_line_distance := 10.0
@export var target_color := Color.RED
@export var normal_color := Color.WHITE

@onready var lines: CrosshairLines = $CrosshairLines
#@onready var hit_lines: CrosshairLines = $HitLines
#@onready var hit_lines_timer: Timer = $HitLinesTimer

#var tw: Tween

#func _ready() -> void:
	#hit_lines.modulate = Color.TRANSPARENT
	#hit_lines_timer.timeout.connect(func(): _hide_hit_lines())
	#_hide_hit_lines()
#
#func _hide_hit_lines():
	#if tw and tw.is_running():
		#return
	#
	#tw = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	#tw.tween_property(hit_lines, "modulate", Color.TRANSPARENT, 0.2)

#func _show_hit_lines():
	#if tw and tw.is_running():
		#tw.kill()
	#
	#tw = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	#tw.tween_property(hit_lines, "modulate", Color.WHITE, 0.2)
	#await tw.finished

func _process(delta: float) -> void:
	var dist = min(player.velocity.length(), max_line_distance)
	lines.update_distance(dist)
	#hit_lines.update_distance()
	
	var color = normal_color
	lines.color = color
	#hit_lines.color = color
