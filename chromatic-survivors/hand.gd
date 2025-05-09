extends ColorShape

func _draw():
	draw_colored_polygon(denormalize(generate_circle_points(69),0.3), Color.BEIGE)
