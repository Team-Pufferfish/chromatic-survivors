extends ColorShape

@export_range(0,1,0.01) var fill: float = 0.5:
	set(value):
		fill = value
		queue_redraw()  # This works in the editor
func _draw():
	draw_polyline(denormalize(generate_circle_points(69), 1.105), Color.BEIGE, 0.05)
	#draw redsquare
	draw_colored_polygon(denormalize(generate_circle_points(69),fill), Color.BEIGE)
