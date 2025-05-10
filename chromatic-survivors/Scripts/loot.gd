extends Node2D
signal loot_get(colour: LightColour)
enum LightColour {RED, BLUE, YELLOW}
var loot_colour = LightColour.BLUE
var target = null
@export var move_speed := 200.0

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


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	target = body
	
func _process(delta: float) -> void:
	if target and is_instance_valid(target):
		var direction = (target.global_position - global_position).normalized()
		position += direction * move_speed * delta
