extends Area2D

@export_multiline var warning = "this requires a child node named 'Props' and prop clones inside it"

var props := []
@onready var spawned_props := $SpawnedProps
@onready var collision_shape := $DefaultCollisionShape2D

var spawn_despawn_effect_tween
func _ready():
	connect("area_entered", spawn_all)
	$DespawnArea.connect("area_exited", despawn_all)
	if get_node_or_null("CollisionShape2D") != null:
		collision_shape = get_node("CollisionShape2D")
		$DefaultCollisionShape2D.queue_free()
	
	spawned_props.modulate = Color.TRANSPARENT
	spawn_despawn_effect_tween = create_tween()
	spawn_despawn_effect_tween.kill()
	
	#save the props
	var existing_props = get_node_or_null("Props")
	if existing_props == null:
		print("missing prop library: " + self.name)
	else:
		for physical_prop in existing_props.get_children():
			var digital_prop = physical_prop.duplicate()
			digital_prop.global_position = physical_prop.global_position
			props.append(digital_prop)
			physical_prop.queue_free()

var already_spawned := false
func spawn_all(_area):
	if !already_spawned:
		already_spawned = true
		# float() to prevent int division warning
		for prop in props:
			var new_prop = prop.duplicate()
			spawned_props.call_deferred("add_child", new_prop)
		spawn_despawn_effect_tween.kill()
		spawn_despawn_effect_tween = create_tween()
		spawn_despawn_effect_tween.parallel().tween_property(spawned_props, "modulate", Color.WHITE, 1.0)

		
func despawn_all(_all):
	if already_spawned:
		already_spawned = false
		spawn_despawn_effect_tween.kill()
		spawn_despawn_effect_tween = create_tween()
		spawn_despawn_effect_tween.parallel().tween_property(spawned_props, "modulate", Color.TRANSPARENT, 1.0)
		spawn_despawn_effect_tween.tween_callback(func(): 
			for civilian in spawned_props.get_children():
				civilian.call_deferred("queue_free")
			)	
