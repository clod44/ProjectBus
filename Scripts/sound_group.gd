extends Node2D

@export_multiline var warning := "put this inside a 'SoundManager'"
@export var group_name = "Default Sound Group"

	
var sounds = {}
func _ready():
	for sound in get_children():
		sounds[sound.name] = sound	

func play_random():
	sounds.values().pick_random().play()
	
func play(sound_name = null):
	sounds[sound_name].play()
	
func stop(sound_name = null):
	sounds[sound_name].stop()
