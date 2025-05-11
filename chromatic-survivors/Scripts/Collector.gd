extends Node2D

var target = null
@export var move_speed := 200.0

func collect_loot():
	for loot in get_tree().get_nodes_in_group("Loot"):
		loot.target = get_tree().get_first_node_in_group("Player")
	queue_free()
	

func _ready() -> void:
	var part_colour = GameColours.WHITE
#
	$Diamond.modulate = part_colour;

func _on_area_2d_body_entered(body: Node2D) -> void:
	collect_loot()

	
func _process(delta: float) -> void:
	if target and is_instance_valid(target):
		var direction = (target.global_position - global_position).normalized()
		position += direction * move_speed * delta
