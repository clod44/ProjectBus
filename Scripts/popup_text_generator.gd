extends Label

@export var color_theme = "red"
@export var color_themes = {
	"red" : [
		Color(10.0, 0.5, 0.5),
		Color(10.0, 0.0, 0.0)
	],
	"yellow" : [
		Color(10.0, 10.0, 10.0),
		Color(10.0, 10.0, 0.0)
	]
}

@onready var effect_timer := $EffectLength
var is_generator = true
var active_effects
func _ready():
	active_effects = get_tree().get_root().get_node("Game/ActiveEffects")
	if is_generator:
		visible = false
		return
	visible = true
	
	apply_color_theme()
	effect_timer.connect("timeout", on_effect_timer_timeout)
	effect_timer.start()
	var tween = create_tween()
	var target_pos = position + Vector2(randf_range(-1, 1),randf_range(-1, 1)).normalized() * randf_range(10, 100)
	tween.tween_property(self, "position", target_pos , 0.5).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate", Color.TRANSPARENT, effect_timer.wait_time - 0.5)

func on_effect_timer_timeout():
	queue_free()

func apply_color_theme():
	if color_themes.has(color_theme):
		var colors = color_themes[color_theme]
		if colors.size() >= 2:
			add_theme_color_override("font_color", colors[0])
			add_theme_color_override("font_outline_color", colors[1])

func create_popup(label_text = "default text", label_theme = null):
	var new_popup = duplicate()
	new_popup.is_generator = false
	new_popup.text = label_text
	if label_theme != null:
		new_popup.color_theme = label_theme
	else:
		new_popup.color_theme = color_theme
	new_popup.global_position = global_position
	active_effects.add_child(new_popup)
	
	
