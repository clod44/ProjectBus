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
	WOMAN_1
}

var civilian_library := {
	CIVILIAN_TYPES.MAN_1 : {
		"idle_sprite" : preload("res://Assets/Textures/Civilians/man_1.png")
	},
	CIVILIAN_TYPES.MAN_2 : {
		"idle_sprite" : preload("res://Assets/Textures/Civilians/man_2.png")
	},
	CIVILIAN_TYPES.WOMAN_1 : {
		"idle_sprite" : preload("res://Assets/Textures/Civilians/woman_1.png")
	},
}
var civilian_data = null 
@export var civilian_type := CIVILIAN_TYPES.MAN_1
@export var random_civilian_type := true

func _ready():
	if random_civilian_type:
		civilian_type = CIVILIAN_TYPES.values().pick_random()
	civilian_data = civilian_library.get(civilian_type)
	
	rotation = randf() * 2.0 * PI
	$Sprite2D.texture = civilian_data["idle_sprite"]


func _process(_delta):
	pass


func take_damage(amount):	
	popup_text_generator.create_popup("DMG+"+str(round(amount)))
	if health <= 0:
		die()



func die():
	$BloodFountain.emitting = true
	$BloodLake.emitting = true
	$BloodExplosion.emitting = true
	$LightOccluder2D.visible = false
	Global.camera.shake(1, 5)
	is_dead = true
	modulate = Color.RED
	var death_tween = create_tween()
	death_tween.tween_property(self, "modulate", Color(1.0, 0.0, 0.0, 0.0), 10.0)
	death_tween.tween_callback(queue_free)
	#queue_free()
