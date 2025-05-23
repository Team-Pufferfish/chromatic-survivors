@tool
extends Node2D

# Dictionary of color names to RGB values
var COLORS = {
	"yellow": Color(1, 1, 0),
	"red": Color(1, 0, 0),
	"blue": Color(0, 0, 1),
	"green": Color(0, 1, 0),
	"orange": Color(1, 0.451, 0),
	"purple": Color(0.5, 0, 0.5),
	"brown": Color(0.6, 0.3, 0.1)
}


#@export_range(0, 100, 1, "or_less", "or_greater") var l: int
# Export the values with a slider in the Inspector, range from 0 to 1
@export_range(0,1,0.01) var yellow_value: float = 0
@export_range(0,1,0.01) var blue_value: float = 0
@export_range(0,1,0.01) var red_value: float = 0

func _process(delta):
	$RedSquare.scale = Vector2(red_value, red_value)
	$BlueSquare.scale = Vector2(blue_value, blue_value)
	$YellowSquare.scale = Vector2(yellow_value, yellow_value)
	
	var green_value = min(blue_value, yellow_value)
	$GreenSquare.scale = Vector2(green_value, green_value)
	var orange_value = min(yellow_value,red_value)
	$OrangeSquare.scale = Vector2(orange_value, orange_value)
	
	var purple_value = min(blue_value, red_value)
	$PurpleSquare.scale = Vector2(purple_value, purple_value)
	
	var brown_value = min(blue_value, red_value, yellow_value)
	$BrownSquare.scale = Vector2(brown_value, brown_value)
	
