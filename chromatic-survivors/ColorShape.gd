@tool
extends Node2D
class_name ColorShape

#@export_range(0, 100, 1, "or_less", "or_greater") var l: int
# Export the values with a slider in the Inspector, range from 0 to 1
@export_range(0,1,0.01) var yellow_value: float = 0.5:
	set(value):
		yellow_value = value
		queue_redraw()  # This works in the editor
@export_range(0,1,0.01) var blue_value: float = 0.5:
	set(value):
		blue_value = value
		queue_redraw()  # This works in the editor
@export_range(0,1,0.01) var red_value: float = 0.5:
	set(value):
		red_value = value
		queue_redraw()  # This works in the editor

# Fixed color values for the color wheel
const COLOR_WHEEL = {
	"red": Color.RED,
	"yellow": Color.YELLOW,
	"blue": Color.BLUE,
	"green": Color.GREEN,
	"orange": Color.DARK_ORANGE,
	"purple": Color.PURPLE,
	"brown": Color.SADDLE_BROWN,
}

# Categorical color logic: no blending, just combinations
func get_color(red: float, yellow: float, blue: float) -> Color:
	var t = 0.01
	var r_on = red > t
	var y_on = yellow > t
	var b_on = blue > t

	if r_on and y_on and b_on:
		return COLOR_WHEEL["brown"] # white
	elif r_on and y_on and not b_on:
		return COLOR_WHEEL["orange"]
	elif y_on and b_on and not r_on:
		return COLOR_WHEEL["green"]
	elif r_on and b_on and not y_on:
		return COLOR_WHEEL["purple"]
	elif r_on and not y_on and not b_on:
		return COLOR_WHEEL["red"]
	elif y_on and not r_on and not b_on:
		return COLOR_WHEEL["yellow"]
	elif b_on and not r_on and not y_on:
		return COLOR_WHEEL["blue"]
	else:
		return Color(1, 1, 1) # fallback to white


func denormalize(normalized_shape: Array, scale_factor: float) -> Array:
	var denormalized_square = []
	# Multiply each point by the scale factor to denormalize
	for point in normalized_shape:
		denormalized_square.append(point * scale_factor)
	
	return denormalized_square
	
# Function to generate normalized rectangle points based on width and height ratios
func generate_rect_points(width: float, height: float) -> Array:
	var points = []
	
	# Normalize the width and height so the largest dimension is scaled to 1
	var max_dim = max(width, height)
	var normalized_width = width / max_dim
	var normalized_height = height / max_dim
	
	# Calculate half width and half height for a centered rectangle
	var half_width = normalized_width / 2
	var half_height = normalized_height / 2
	
	# Define the four corners of the normalized rectangle
	points.append(Vector2(-half_width, half_height))  # Top-left corner
	points.append(Vector2(half_width, half_height))   # Top-right corner
	points.append(Vector2(half_width, -half_height))  # Bottom-right corner
	points.append(Vector2(-half_width, -half_height)) # Bottom-left corner
	
	# Ensure the rectangle is closed by adding the first point at the end
	points.append(points[0])
	
	return points
	
func generate_circle_points(num_points: int) -> Array:
	# Create an empty array to store the points
	var points = []
	
	# Generate points along the circle
	var initial_point
	
	for i in range(num_points):
		var angle = 2 * PI * i / num_points  # Evenly spaced angles around the circle
		
		var x = cos(angle)  # X coordinate on the unit circle
		var y = sin(angle)  # Y coordinate on the unit circle
		points.append(Vector2(x, y))  # Add the point to the array
		if i == 0:
			initial_point = Vector2(x,y)
	
	points.append(initial_point)
	
	return points
