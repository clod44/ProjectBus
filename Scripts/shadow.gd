extends Node

@export var texture := preload("res://Assets/Textures/Particles/light_04.png")
@export var copy_parent_texture := true
@onready var sprite := $Sprite2D
@export var modulate := Color(0.0, 0.0, 0.0, 0.5)
@export var shadow_height := 10.0
@onready var my_parent := get_parent()
# Called when the node enters the scene tree for the first time.
func _ready():
	my_parent.connect("ready", on_parent_ready)
	
func on_parent_ready():
	if copy_parent_texture:
		sprite.texture = my_parent.texture
	else:
		sprite.texture = texture
	sprite.modulate = modulate
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	sprite.global_position = my_parent.global_position + Global.sun_direction * shadow_height
	sprite.global_rotation = my_parent.global_rotation
	sprite.scale = my_parent.scale
