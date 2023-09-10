extends Node

@export var follow_source : Node2D
@export var force_follow_parent := false
@export var is_visible := false
@export var trail_length := 10
@export var trail_width := 10.0
@export var trail_width_curve : Curve
@onready var line2D = $Line2D
@export var trail_color : Gradient

@export var modulate_color := Color.WHITE

var point
func _ready():
	if force_follow_parent:
		follow_source = get_parent()
	line2D.width = trail_width
	line2D.width_curve = trail_width_curve
	line2D.gradient = trail_color
	line2D.modulate = modulate_color
	
func _physics_process(_delta):
	if is_visible && is_instance_valid(follow_source):
		point = follow_source.global_position
		line2D.add_point(point)
		if line2D.points.size() > trail_length:
			line2D.remove_point(0)
	else:
		#line2D.points = []
		if line2D.points.size() > 0:
			line2D.remove_point(0)
