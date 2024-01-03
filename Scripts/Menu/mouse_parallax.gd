extends Control


@export var parallax_strength = 0.01
@export var smoothness := 0.1
var nodes = {}
func _ready():
	for node in get_children():
		if "global_position" in node:
			nodes[node.name] = {
				"default_position" : node.global_position,
				"node" : node
			}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var parallax_offset = (get_global_mouse_position() - size *0.5) * parallax_strength
	for node_data in nodes.values():
		node_data["node"].global_position = lerp(
			node_data["node"].global_position,
			node_data["default_position"] - parallax_offset,
			smoothness
			)
