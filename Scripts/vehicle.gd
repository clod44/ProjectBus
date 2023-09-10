extends RigidBody2D


@export var vehicle_speed := 100000.0

@export var steer_strength := 10000000.0
var steer_force := 0.0

@onready var wheel_fl_sprite := $WheelFL
@onready var wheel_fr_sprite := $WheelFR
@onready var wheel_bl_sprite := $WheelBL
@onready var wheel_br_sprite := $WheelBR

func _ready():
	connect("body_entered", on_body_enter)


func on_body_enter(body):
	if body is RigidBody2D:
		if "is_dead" in body:
			if !body.is_dead:
				body.apply_impulse(linear_velocity * 0.1)
		else:
			body.apply_impulse(linear_velocity * 0.1)
			
	if "health" in body:
		body.health -= linear_velocity.length() * 0.5
var move_force := 0.0

func _process(_delta):
	move_force = Input.get_action_strength("throttle") * vehicle_speed
	steer_force = steer_strength * (Input.get_action_strength("steer_right") - Input.get_action_strength("steer_left"))
	
	
	wheel_fl_sprite.rotation = lerp(wheel_fl_sprite.rotation, sign(steer_force) * PI * 0.20, 0.05)
	wheel_fr_sprite.rotation = wheel_fl_sprite.rotation
	
func _physics_process(delta):
	apply_torque(steer_force * delta)
	apply_force(Vector2(0,-move_force).rotated(global_rotation) * delta)
