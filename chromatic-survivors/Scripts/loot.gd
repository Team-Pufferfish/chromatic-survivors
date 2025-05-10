extends Node2D
signal loot_get(colour: LightColour)
enum LightColour {RED, BLUE, YELLOW}
var loot_colour = LightColour.BLUE

func collect_loot():
	emit_signal("loot_get", loot_colour)
	queue_free()
	

func _ready() -> void:
	var part_colour = GameColours.WHITE
	match loot_colour:
		LightColour.RED:
			part_colour = GameColours.RED
		LightColour.BLUE:
			part_colour = GameColours.BLUE
		LightColour.YELLOW:
			part_colour = GameColours.YELLOW

	$Diamond.modulate = part_colour;

func _on_area_2d_body_entered(body: Node2D) -> void:
	collect_loot()
