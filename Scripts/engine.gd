extends Marker2D

## in this code engine, i kinda used "rpm" as the term "torque". sorry for that future me

@export_multiline var warning := "you can put your custom soundstreamer2d('EngineSound1' and 2) as a child to this. or this will use a default engine sound"
var vehicle :RigidBody2D= get_parent() 
var current_gear := 2
var is_engine_in_reverse := false
@export var gear_sizes := [
	1.0, # reverse
	0.0001, # neutral
	1.0,
	1.5,
	2.0,
	3.0,
]
@export var throttle_power := .5
var rpm := 0.0
@export var rpm_lose_strength = 0.2
var engine_power_export := 0.0

@onready var engine_sound_1 := $DefaultEngineSound1
@onready var engine_sound_2 := $DefaultEngineSound2
@export var engine_pitch_scale_factor := 1.0
@onready var gear_shift_sound := $GearShiftSound
@onready var road_sound := $RoadSound
@onready var clutch_timer := $ClutchTimer
func _ready():
	if get_node_or_null("EngineSound1"):
		engine_sound_1 = get_node("EngineSound1")
	if get_node_or_null("EngineSound2"):
		engine_sound_2 = get_node("EngineSound2")
	clutch_timer.connect("timeout", on_clutch_release)

var clutch := false
var new_gear_after_clutch := 1
func on_clutch_release():
	current_gear = new_gear_after_clutch
	clutch = false
	if current_gear == 0:
		is_engine_in_reverse = true
	else: 
		is_engine_in_reverse = false
	gear_shift_sound.play()
	## this doesnt make much sense and it doesnt sound good
	#if new_gear_after_clutch < old_gear:
	#	rpm = remap(rpm, 0, gear_sizes[current_gear], 0, gear_sizes[old_gear])

func _process(delta):
	
	if !clutch:
		if Input.is_action_just_pressed("shift_up"):
			if current_gear + 1 < gear_sizes.size():
				clutch = true
				new_gear_after_clutch = current_gear + 1
				clutch_timer.start()
		elif Input.is_action_just_pressed("shift_down"):
			if current_gear - 1 >= 0:
				clutch = true
				new_gear_after_clutch = current_gear - 1
				clutch_timer.start()
	
	
	if Input.is_action_pressed("throttle") and !clutch:
		if current_gear == 1: # neutral
			rpm += throttle_power * delta
		else:
			rpm += throttle_power / gear_sizes[current_gear] * delta
	else:
		rpm -= rpm_lose_strength * delta
		
	if rpm >= 1.0:
		rpm -= randf() * 0.07
	rpm = clamp(rpm, 0, 1)
	
	engine_power_export = rpm * gear_sizes[current_gear]
	engine_power_export *= -1 if is_engine_in_reverse else 1
	
	engine_sound_1.pitch_scale = 1 + (rpm * engine_pitch_scale_factor)
	engine_sound_2.pitch_scale = 1 + (rpm * engine_pitch_scale_factor)
	road_sound.pitch_scale = 1 + (rpm * engine_pitch_scale_factor)
	
	#engine_sound_1.set_volume_db(lin_to_db(1-rpm))
	engine_sound_2.set_volume_db(lin_to_db(rpm))
	road_sound.set_volume_db(lin_to_db(rpm * 2.0))

func lin_to_db(lin):
	return 10.0 * log(lin)

