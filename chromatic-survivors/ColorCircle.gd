extends ColorShape

func _draw():
	draw_polyline(denormalize(generate_circle_points(40), 1.1), get_color(red_value, yellow_value, blue_value), 0.05)
	
	#draw redsquare
	draw_colored_polygon(denormalize(generate_circle_points(40),red_value), get_color(1,0,0))
	draw_colored_polygon(denormalize(generate_circle_points(40),yellow_value), get_color(0,1,0))
	draw_colored_polygon(denormalize(generate_circle_points(40),blue_value), get_color(0,0,1))
	#
	draw_colored_polygon(denormalize(generate_circle_points(40),min(red_value, yellow_value)), get_color(1,1,0))
	draw_colored_polygon(denormalize(generate_circle_points(40),min(red_value, blue_value)), get_color(1,0,1))
	draw_colored_polygon(denormalize(generate_circle_points(40),min(yellow_value, blue_value)), get_color(0,1,1))
	#
	draw_colored_polygon(denormalize(generate_circle_points(40),min(red_value,yellow_value,blue_value)), get_color(red_value,yellow_value,blue_value))
	
