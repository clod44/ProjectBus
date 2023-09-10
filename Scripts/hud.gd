extends CanvasLayer



var vehicle = null
var vehicle_engine = null

## rpmg and current gear
@export var gauge_1 : Sprite2D
## speed
@export var gauge_2 : Sprite2D
func _ready():
	Global.connect("vehicle_updated", on_vehicle_update)
	on_vehicle_update()

func on_vehicle_update():
	vehicle = Global.vehicle
	vehicle_engine = vehicle.get_node_or_null("Engine")

func _process(_delta):
	if vehicle_engine != null:
		gauge_1.value = vehicle_engine.rpm * 1000
		gauge_1.text_2 = str(vehicle_engine.current_gear-1)
		gauge_2.value = vehicle.linear_velocity.length() * 0.03
		gauge_2.text_2 = str(vehicle_engine.current_gear-1)
