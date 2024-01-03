extends Control


@onready var texture_rect : TextureRect = $TextureRect
# this timer automaticly starts and keeps looping
@onready var delay_timer : Timer = $Delay
@export var slideshow_speed := 3.0
@export var image_library := [
	preload("res://Assets/Textures/UI/Backgrounds/bus_1.jpg"),
	preload("res://Assets/Textures/UI/Backgrounds/bus_2.jpg"),
	preload("res://Assets/Textures/UI/Backgrounds/bus_3.jpg"),
	preload("res://Assets/Textures/UI/Backgrounds/bus_4.jpg"),
	preload("res://Assets/Textures/UI/Backgrounds/bus_5.jpg"),
	preload("res://Assets/Textures/UI/Backgrounds/bus_6.jpg"),
	preload("res://Assets/Textures/UI/Backgrounds/bus_7.jpg"),
	preload("res://Assets/Textures/UI/Backgrounds/bus_8.jpg")
]
@export var bg_color := Color.BLACK
@export var fade_duration := 2.0
func _ready():
	$ColorRect.color = bg_color
	delay_timer.stop()
	delay_timer.wait_time = slideshow_speed
	delay_timer.start()
	delay_timer.connect("timeout", on_timer_timeout)
	on_timer_timeout()


func on_timer_timeout():
	delay_timer.paused = true
	var fade_out_tween = create_tween()
	fade_out_tween.tween_property(texture_rect, "modulate", Color.TRANSPARENT, fade_duration *0.5)
	fade_out_tween.tween_callback(func():
		var random_image = image_library.pick_random()
		var max_iterations = 10
		while random_image == texture_rect.texture or max_iterations > 0:
			random_image = image_library.pick_random()
			max_iterations -= 1
			
		texture_rect.texture = random_image 
		var fade_in_tween = create_tween()
		fade_in_tween.tween_property(texture_rect, "modulate", Color.WHITE, fade_duration *0.5)
		fade_in_tween.tween_callback(func():
			delay_timer.paused = false
			)
		)
