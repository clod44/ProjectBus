extends Area2D


var civilian_scene := preload("res://Scenes/civilian.tscn")
@export var spawn_amount := 10
@export var spawn_amount_variation := 0.3

@onready var spawned_civilians := $SpawnedCivilians
@onready var collision_shape := $DefaultCollisionShape2D
var spawn_radius = 1

@export var min_spawn_delay := 10.0
@onready var spawn_delay_timer := $SpawnDelay
func _ready():
	connect("area_entered", spawn_triggered)
	$DespawnArea.connect("area_exited", despawn_triggered)
	if get_node_or_null("CollisionShape2D") != null:
		collision_shape = get_node("CollisionShape2D")
		$DefaultCollisionShape2D.queue_free()
	spawn_radius = collision_shape.shape.radius
	spawn_delay_timer.wait_time = min_spawn_delay
	print(spawn_delay_timer.time_left)
	
	spawn_delay_timer.stop()
	
var already_spawned := false
func spawn_triggered(_area):
	if already_spawned or !spawn_delay_timer.is_stopped():
		return
	already_spawned = true
	spawn_delay_timer.start()
	for i in spawn_amount:
		var new_civilian = civilian_scene.instantiate()
		var random_pos = global_position + (Vector2.ONE.rotated(randf() * 2 * PI) * randf() * spawn_radius * 0.5)
		new_civilian.global_position = random_pos
		spawned_civilians.call_deferred("add_child",new_civilian)
	
func despawn_triggered(_area):
	already_spawned = false
	for civilian in spawned_civilians.get_children():
		civilian.call_deferred("queue_free")
	
