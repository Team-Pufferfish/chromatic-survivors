extends Area2D

func generate_cone(details : ColorLevel):
	var points = []
	var segments_total = 24
	# How much of the circle this slice takes
	var slice_fraction = float(details.segments) / segments_total
	var slice_angle = TAU * slice_fraction
	var angle_offset = -slice_angle / 2.0  # Offset so slice is centered around angle 0 (positive X)

	if details.segments < segments_total:
		points.append(Vector2(0, 0))  # Center point for pie slice

	for i in range(details.segments + 1):  # +1 to fully close the arc
		var t = float(i) / details.segments
		var angle = angle_offset + (t * slice_angle)
		var x = cos(angle) * details.radius
		var y = sin(angle) * details.radius
		points.append(Vector2(x, y))

	if details.segments < segments_total:
		points.append(Vector2(0, 0))  # Optional: close the shape cleanly

	$Polygon2D.polygon = points
	$LightColor.polygon = points
