extends RigidBody2D


@export var vehicle_speed := 100000.0

@export var steer_strength := 10000000.0
var steer_force := 0.0
@export var brake_strength := 1000.0
@onready var wheel_fl_sprite := $Wheels/WheelFL
@onready var wheel_fr_sprite := $Wheels/WheelFR
@onready var wheel_bl_sprite := $Wheels/WheelBL
@onready var wheel_br_sprite := $Wheels/WheelBR
@onready var engine := $Engine
@onready var sound_manager := $SoundManager

var is_drifting = true :
	set(value):
		var old_value = is_drifting
		is_drifting = value
		
		if old_value == is_drifting:
			return
		if tiremarks[0] != null:
			for tiremark in tiremarks:
				tiremark.emitting = is_drifting
			for tire_smoke in tire_smokes:
				tire_smoke.emitting = is_drifting
			if is_drifting:
				sound_manager.play_from_group("UtilSounds", "WheelScreaming")
			else:
				sound_manager.stop_from_group("UtilSounds", "WheelScreaming")
@export var drift_angle_threshold = 25.0
@export var drift_speed_threshold = 500.0
@onready var tiremarks := [
	$Wheels/WheelFL/TireMarkFL,
	$Wheels/WheelFR/TireMarkFR,
	$Wheels/WheelBL/TireMarkBL,
	$Wheels/WheelBR/TireMarkBR
]
@onready var tire_smokes := [
	$Wheels/WheelFL/SmokeFL,
	$Wheels/WheelFR/SmokeFR,
	$Wheels/WheelBL/SmokeBL,
	$Wheels/WheelBR/SmokeBR
]

func _ready():
	connect("body_entered", on_body_enter)
	Global.vehicle = self

func on_body_enter(body):
	var linear_vel_len = linear_velocity.length()
	if body is RigidBody2D:
		Global.camera.shake(1, 1)
		if "is_dead" in body:
			if !body.is_dead:
				body.apply_impulse(linear_velocity * 0.1)
				body.apply_torque_impulse(randf_range(-1, 1) * linear_vel_len * 10)
		else:
			body.apply_impulse(linear_velocity * 0.1)
			body.apply_torque_impulse(randf_range(-1, 1) * linear_vel_len)
	if "health" in body:
		body.health -= linear_vel_len * 0.5
		sound_manager.play_random_from_group("HitSounds")
var move_force := 0.0

func _process(_delta):
	move_force = Input.get_action_strength("throttle") * vehicle_speed * engine.engine_power_export
	
	steer_force = steer_strength * (Input.get_action_strength("steer_right") - Input.get_action_strength("steer_left"))
	
	wheel_fl_sprite.rotation = lerp(wheel_fl_sprite.rotation, (-1.0 if engine.is_engine_in_reverse else 1.0) * sign(steer_force) * PI * 0.20, 0.05)
	wheel_fr_sprite.rotation = wheel_fl_sprite.rotation
	
	if linear_velocity.length() > drift_speed_threshold:
		var velocity = linear_velocity.normalized()
		if !velocity.is_zero_approx():
			var forward = Vector2.from_angle(global_rotation - PI*0.5)
			var angle = forward.angle_to(velocity)
			is_drifting = abs(angle) > deg_to_rad(drift_angle_threshold)
	else:
		is_drifting = false

func _physics_process(delta):
	apply_torque(steer_force * delta * min(abs(engine.engine_power_export), 1))
	apply_force(Vector2(0,-move_force).rotated(global_rotation) * delta)
