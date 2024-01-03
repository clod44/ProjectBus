extends RigidBody2D

@onready var popup_text_generator := $PopupTextGenerator
@onready var collision_shape := $CollisionShape2D
var is_dead := false :
	set(value):
		is_dead = value
		if collision_shape != null:
			collision_shape.set_deferred("disabled", is_dead)
@export var health := 100.0 :
	set(value):
		var old_health = health
		health = value
		var health_difference = old_health - health
		if health_difference != 0:
			take_damage(health_difference)

enum CIVILIAN_TYPES {
	MAN_1,
	MAN_2,
	MAN_3,
	MAN_4,
	WOMAN_1,
	WOMAN_2
}

#i used "woman" and "female" interchangable in my workplace and i hate myself
var civilian_library := {
	CIVILIAN_TYPES.MAN_1 : {
		"idle_sprite" : preload("res://Assets/Textures/Civilians/man_1.png"),
		"gender": "male"	
	},
	CIVILIAN_TYPES.MAN_2 : {
		"idle_sprite" : preload("res://Assets/Textures/Civilians/man_2.png"),
		"gender": "male"
	},
	CIVILIAN_TYPES.MAN_3 : {
		"idle_sprite" : preload("res://Assets/Textures/Civilians/man_3.png"),
		"gender": "male"
	},
	CIVILIAN_TYPES.MAN_4 : {
		"idle_sprite" : preload("res://Assets/Textures/Civilians/man_4.png"),
		"gender": "male"
	},
	CIVILIAN_TYPES.WOMAN_1 : {
		"idle_sprite" : preload("res://Assets/Textures/Civilians/woman_1.png"),
		"gender": "female"
	},
	CIVILIAN_TYPES.WOMAN_2 : {
		"idle_sprite" : preload("res://Assets/Textures/Civilians/woman_2.png"),
		"gender": "female"
	},
}


@onready var sprite = $Sprite2D
var civilian_data = null 
@export var civilian_type := CIVILIAN_TYPES.MAN_1
@export var random_civilian_type := true

@onready var sound_manager := $SoundManager

var dead_sprite_texture = [
	preload("res://Assets/Textures/Civilians/corpse_1.png"),
	preload("res://Assets/Textures/Civilians/corpse_2.png"),
	preload("res://Assets/Textures/Civilians/corpse_3.png")
].pick_random()

@export var move_speed := 5000.0
@export var move_speed_variation := 0.5

func _ready():
	if random_civilian_type:
		civilian_type = CIVILIAN_TYPES.values().pick_random()
	civilian_data = civilian_library.get(civilian_type)
	
	rotation = randf() * 2.0 * PI
	sprite.texture = civilian_data["idle_sprite"]
	move_speed += move_speed * randf_range(-1, 1) * move_speed_variation


func _process(_delta):
	pass

func _physics_process(delta):
	apply_force(Vector2(0, move_speed).rotated(global_rotation) * delta)


func take_damage(amount):	
	sound_manager.play_random_from_group("ManHitSounds" if civilian_data["gender"] == "male" else "WomanHitSounds")
	popup_text_generator.create_popup("DMG+"+str(round(amount)))
	if health <= 0:
		move_speed = 0
		sprite.texture = dead_sprite_texture
		sprite.set_flip_h(randf() > 0.5)
		sprite.set_flip_v(randf() > 0.5)

		die()



func die():
	$BloodFountain.emitting = true
	$BloodLake.emitting = true
	$BloodExplosion.emitting = true
	$LightOccluder2D.visible = false
	Global.camera.shake(1, 5)
	is_dead = true
	#modulate = Color.RED
	var death_tween = create_tween()
	death_tween.tween_property(self, "modulate", Color(1.0, 0.0, 0.0, 0.0), 10.0)
	death_tween.tween_callback(queue_free)
	#queue_free()
