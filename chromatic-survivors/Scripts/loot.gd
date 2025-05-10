extends Node2D
signal loot_get(colour: GameColours)
var loot_colour = GameColours.WHITE

func collect_loot():
	emit_signal("loot_get", loot_colour)
	queue_free()
	

func _ready() -> void:
	$Diamond.modulate = loot_colour;

func _on_area_2d_body_entered(body: Node2D) -> void:
	collect_loot()
