extends RigidBody2D

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
		if old_health != health:
			take_damage()

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


func take_damage():
	if health <= 0:
		die()



func die():
	is_dead = true
	modulate = Color.RED
	#queue_free()
