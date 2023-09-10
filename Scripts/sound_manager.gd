extends Node2D


var sound_groups = {}

func _ready():
	for group in get_children():
		sound_groups[group.group_name] = group

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func play_random_from_group(group_name = null):
	sound_groups[group_name].play_random()
