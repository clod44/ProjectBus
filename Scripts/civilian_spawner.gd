extends Area2D


var civilian_scene := preload("res://Scenes/civilian.tscn")
@export var spawn_amount := 10
@export var spawn_amount_variation := 0.3

@onready var spawned_civilians := $SpawnedCivilians
@onready var collision_shape := $DefaultCollisionShape2D
var spawn_radius = 1

var should_spawn = false

var spawn_despawn_effect_tween
func _ready():
	visible = true
	connect("area_entered", spawn_all)
	$DespawnArea.connect("area_exited", despawn_all)
	if get_node_or_null("CollisionShape2D") != null:
		collision_shape = get_node("CollisionShape2D")
		$DefaultCollisionShape2D.queue_free()
	spawn_radius = collision_shape.shape.radius
	
	spawned_civilians.modulate = Color.TRANSPARENT
	spawn_despawn_effect_tween = create_tween()
	spawn_despawn_effect_tween.kill()
	
var already_spawned := false

func spawn_all(_area):
	if already_spawned:
		return
	already_spawned = true
	# float() to prevent int division warning
	for i in spawn_amount:
		var new_civilian = civilian_scene.instantiate()
		var random_pos = global_position + (Vector2.ONE.rotated(randf() * 2 * PI) * randf() * spawn_radius * 0.5)
		new_civilian.global_position = random_pos
		spawned_civilians.call_deferred("add_child",new_civilian)

	spawn_despawn_effect_tween.kill()
	spawn_despawn_effect_tween = create_tween()
	spawn_despawn_effect_tween.parallel().tween_property(spawned_civilians, "modulate", Color.WHITE, 1.0)
		
func despawn_all(_area):
	if !already_spawned:
		return
	already_spawned = false
	spawn_despawn_effect_tween.kill()
	spawn_despawn_effect_tween = create_tween()
	spawn_despawn_effect_tween.parallel().tween_property(spawned_civilians, "modulate", Color.TRANSPARENT, 1.0)
	spawn_despawn_effect_tween.tween_callback(func(): 
		for civilian in spawned_civilians.get_children():
			civilian.call_deferred("queue_free")
		)	
