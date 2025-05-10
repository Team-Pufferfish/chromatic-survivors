extends Node2D

@export var grid_spacing: float = 128.0
@export var line_color: Color = Color(1, 1, 1, 0.4)
@export var line_thickness: float = 1.0
@export var draw_range: float = 2000.0  # How far to draw grid in each direction

func _process(_delta):
	queue_redraw()

func _draw():
	var cam := get_viewport().get_camera_2d()
	if cam == null:
		return

	var cam_pos = cam.global_position
	var start_x = floor((cam_pos.x - draw_range) / grid_spacing) * grid_spacing
	var end_x = floor((cam_pos.x + draw_range) / grid_spacing) * grid_spacing
	var start_y = floor((cam_pos.y - draw_range) / grid_spacing) * grid_spacing
	var end_y = floor((cam_pos.y + draw_range) / grid_spacing) * grid_spacing

	for x in range(start_x, end_x + 1, int(grid_spacing)):
		draw_line(
			Vector2(x, start_y),
			Vector2(x, end_y),
			line_color,
			line_thickness
		)

	for y in range(start_y, end_y + 1, int(grid_spacing)):
		draw_line(
			Vector2(start_x, y),
			Vector2(end_x, y),
			line_color,
			line_thickness
		)
