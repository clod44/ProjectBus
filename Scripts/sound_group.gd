extends Node2D

@export_multiline var warning := "put this inside a 'SoundManager'"
@export var group_name = "Default Sound Group"

	

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func play_random():
	get_children().pick_random().play()
