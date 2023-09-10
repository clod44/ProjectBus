extends Sprite2D

@onready var label_1 := $Label1
@onready var label_2 := $Label2
@onready var progress_line := $Progress

@export var text_1 := "Text"
@export var text_2 := "N"
@export var min_value := 0.
@export var max_value := 100.0
@export var value := 0.0 

@export var start_angle := 270.0
@export var end_angle := 400.0
func _ready():
	update_visuals()

func _process(_delta):
	update_visuals()
	
func update_visuals():
	label_1.text = text_1 + str(round(value))
	label_2.text = text_2
	progress_line.rotation = deg_to_rad(
		wrapf(
			remap(value, min_value, max_value, start_angle, end_angle),
		 	-180, 180
			)
		)
