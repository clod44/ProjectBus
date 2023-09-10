extends Camera2D


@export_multiline var warning := "make sure to place this at top most of the scene as possible"
@export_subgroup("Camera")
## node that the camera will follow by setting the target_pos the node's global_position
@export var follow_node : Node2D
## if follow_node exists, this will be overwritten
@export var target_pos : Vector2
## camera smooth follow interpolation value 
## [br]0.1 = smooth camera follow
## [br]1.0 = instant camera snap 
@export var smoothing_speed := 0.3

@export var mouse_offset_factor := 0.01
var desired_zoom := 1.0
var current_zoom := 1.0

@export_group("Zooming")
## zoom speed/smoothness
@export var zoom_interpolation := 0.1
@export_subgroup("Day Zooming")
@export var day_zoom_time := 12.0
@export var max_day_zoom := 1.0
@export var min_day_zoom := 2.0

@export_subgroup("Night Zooming")
@export var night_zoom_time := 3.0
@export var max_night_zoom := 1.0
@export var min_night_zoom := 2.0

@export_subgroup("Camera Shake")
var shake_amount := 1.0 #this represent the t of shaking 1 to 0 expoential decay. dont touch this
var shake_strength := 5.0
var default_offset = offset
@onready var tween = create_tween()
@onready var timer = $Timer
var shaking = false


func _ready():
	#see https://www.youtube.com/watch?v=4mll7LKIITM for camera shaking stuff and global accessing
	Global.camera = self
	randomize() #randomize RNG seed
	
	# have to stop it manually after creation otherwise Godot complains
	tween.kill()
	
	#init
	if follow_node:
		target_pos = follow_node.global_position
	else:
		target_pos = Vector2.ZERO
	global_position = target_pos


func _physics_process(delta):
	if is_instance_valid(follow_node):
		target_pos = follow_node.global_position
	var smoothed_pos = global_position.lerp(target_pos, smoothing_speed * delta * 60)
	global_position = smoothed_pos + get_local_mouse_position() * mouse_offset_factor 
	
	if(Input.is_action_just_released("zoom_in")):
		desired_zoom -= 1
	elif(Input.is_action_just_released("zoom_out")):
		desired_zoom += 1
	
	var hours = fmod(Global.game_time_minutes / 60.0, 24)
	var night_zoom_factor = abs(remap(hours, day_zoom_time, night_zoom_time, 0, 1))
	desired_zoom = clamp(
		desired_zoom, 
		lerp(max_day_zoom, max_night_zoom, night_zoom_factor),
		lerp(min_day_zoom, min_night_zoom, night_zoom_factor)
		)
	current_zoom = lerp(current_zoom, desired_zoom, zoom_interpolation * delta * 60)
	zoom = Vector2(current_zoom, current_zoom)
	
	if shaking:
		offset = Vector2(randf_range(-1, 1) * shake_strength * shake_amount, randf_range(-1, 1) * shake_strength * shake_amount)
		shake_amount *= max(shake_amount - 0.01, 0)


func shake(time, _shake_strength):
	timer.wait_time = time
	shake_amount = 1 #reset exponential decay
	shake_strength = _shake_strength
	shaking = true
	timer.start()


func _on_timer_timeout():
	shaking = false
	
	# have to stop it manually after creation otherwise Godot complains
	tween.kill()
	tween = create_tween()
	tween.tween_property(self, "offset", default_offset, 2.0)
