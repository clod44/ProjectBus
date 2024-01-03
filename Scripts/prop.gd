extends RigidBody2D

@export_multiline var warning := "needs 'SpriteNormal', 'SpriteDestroyed', 'CollisionShape2D'"
@export var prop_name := "Street Bank"
@export var health := 100.0 :
	set(value):
		var old_value = health
		health = value
		if old_value > health:
			take_damage()
## default sprite
@onready var sprite_normal := $SpriteNormal
## destroyed sprite
@onready var sprite_destroyed := $SpriteDestroyed
## collision shape
@onready var collision_shape := $CollisionShape2D

@export var fade_out_time := 20.0
@export var random_destroy_direction := false

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite_normal.visible = true
	sprite_destroyed.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func take_damage():
	if health <= 0:
		destroy()

func destroy():
	sprite_normal.visible = false
	if random_destroy_direction:
		sprite_destroyed.global_rotation = randf() * PI * 2.0
	sprite_destroyed.visible = true
	collision_shape.set_deferred("disabled", true)
	var destroy_tween = create_tween()
	destroy_tween.tween_property(self, "modulate", Color.TRANSPARENT, fade_out_time)
	destroy_tween.tween_callback(func():
		queue_free()
		)
