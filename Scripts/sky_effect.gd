extends CanvasModulate

var game_time_hours := 0.0

@export var sky_colors = {	
	4.0 : Color.WHITE,
	6.0 : Color.WHITE,
	12.0 : Color.WHITE,
	20.0 : Color.WHITE,
	23.99 : Color.WHITE
}

func _ready():
	sky_colors[0.01] = sky_colors.values()[sky_colors.size()-1]

func _process(_delta):
	game_time_hours = fmod(Global.game_time_minutes / 60.0, 24.0)
	color = get_sky_color()

func get_sky_color():
	var current_hour = fmod(game_time_hours + 24.0, 24.0)  # Ensure positive and within a 24-hour cycle

	var color_keys = sky_colors.keys()
	var previous_key = color_keys[color_keys.size() - 1]
	var next_key = color_keys[0]

	# Find the previous and next keys relative to the current hour
	for key in color_keys:
		if key > current_hour:
			next_key = key
			break
		previous_key = key
	# Handle the cyclic nature of time
	if previous_key > next_key:
		next_key += 24.0
	
	# Calculate the normalized time based on the previous and next keys
	var normalized_time = (current_hour - previous_key) / (next_key - previous_key)
	# Interpolate the colors based on normalized time
	var interpolated_color = sky_colors[previous_key].lerp(sky_colors[next_key], normalized_time)
	return interpolated_color

