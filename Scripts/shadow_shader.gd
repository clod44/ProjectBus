extends ColorRect

@export_multiline var warning := "put this inside a sprite"
@export var shadow_color := Color(0.0 ,0.0, 0.0, 0.5)
@export var shadow_length := 5.0
@export var update_shadows_from_this := false


var shader_material : ShaderMaterial
var my_parent : Sprite2D
func _ready():
	my_parent = get_parent()
	var sprite_size = my_parent.get_rect().size
	#size = sprite_size # this makes it expand from one side
	custom_minimum_size = sprite_size
	
	shader_material = material as ShaderMaterial
	shader_material.set_shader_parameter("shadow_color", shadow_color)
	shader_material.set_shader_parameter("shadow_length", shadow_length)
	shader_material.set_shader_parameter("sprite_texture", my_parent.texture)
	
func _process(_delta):
	shader_material.set_shader_parameter("my_rotation", my_parent.global_rotation)
	
	if update_shadows_from_this:
		shader_material.set_shader_parameter("shadow_dir", Global.shadow_direction)
	
		
