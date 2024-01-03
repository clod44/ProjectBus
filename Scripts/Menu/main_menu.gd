extends CanvasLayer

@export var btn_continue : Button
@export var continue_scene : PackedScene
@export var btn_new_game: Button
@export var new_game_scene : PackedScene
@export var btn_options: Button
@export var options_scene : PackedScene
@export var btn_credits: Button
@export var credits_scene : PackedScene
@export var btn_quit: Button

func _ready():
	$FadeInOut.visible = true
	btn_continue.connect("pressed", _on_btn_continue_pressed)
	btn_new_game.connect("pressed", _on_btn_new_game_pressed)
	btn_options.connect("pressed", _on_btn_options_pressed)
	btn_credits.connect("pressed", _on_btn_credits_pressed)
	btn_quit.connect("pressed", _on_btn_quit_pressed)

func _process(_delta):
	pass

func _on_btn_continue_pressed():
	if continue_scene != null:
		get_tree().change_scene_to_packed(continue_scene)

func _on_btn_new_game_pressed():
	if new_game_scene != null:
		get_tree().change_scene_to_packed(new_game_scene)

func _on_btn_options_pressed():
	if options_scene != null:
		get_tree().change_scene_to_packed(options_scene)

func _on_btn_credits_pressed():
	if credits_scene != null:
		get_tree().change_scene_to_packed(credits_scene)

func _on_btn_quit_pressed():
	get_tree().quit()
