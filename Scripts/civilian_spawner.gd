extends Area2D


var civilian_scene := preload("res://Scenes/civilian.tscn")
@export var spawn_amount := 10
## spread the spawn amount in multiple frames 
@export var spawn_amount_spread := 10
@export var spawn_amount_variation := 0.3

@onready var spawned_civilians := $SpawnedCivilians
@onready var collision_shape := $DefaultCollisionShape2D
var spawn_radius = 1

@export var min_spawn_delay := 10.0
@onready var spawn_delay_timer := $SpawnDelay

var should_spawn = false
func _ready():
	connect("area_entered", on_spawn_area_enter)
	$DespawnArea.connect("area_exited", despawn_triggered)
	if get_node_or_null("CollisionShape2D") != null:
		collision_shape = get_node("CollisionShape2D")
		$DefaultCollisionShape2D.queue_free()
	spawn_radius = collision_shape.shape.radius
	spawn_delay_timer.wait_time = min_spawn_delay
	
	spawn_delay_timer.stop()
	
var already_spawned := false
var finished_spawn_spreads = 0

func _process(_delta):
	if should_spawn and !already_spawned and spawn_delay_timer.is_stopped():
		spawn_triggered()

func spawn_triggered():
	# float() to prevent int division warning
	for i in ceil(spawn_amount / float(spawn_amount_spread)) :
		var new_civilian = civilian_scene.instantiate()
		var random_pos = global_position + (Vector2.ONE.rotated(randf() * 2 * PI) * randf() * spawn_radius * 0.5)
		new_civilian.global_position = random_pos
		spawned_civilians.call_deferred("add_child",new_civilian)
	finished_spawn_spreads += 1
	if finished_spawn_spreads >= spawn_amount_spread:
		finished_spawn_spreads = 0
		spawn_delay_timer.start()
		already_spawned = true
		should_spawn = false
		
func despawn_triggered(_area):
	already_spawned = false
	for civilian in spawned_civilians.get_children():
		civilian.call_deferred("queue_free")

func on_spawn_area_enter(_area):
	should_spawn = true
