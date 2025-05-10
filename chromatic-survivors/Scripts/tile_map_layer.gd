extends TileMap

@export var player_path: NodePath
var player: Node2D

func _ready():
	player = get_node(player_path)

func _process(delta):
	if is_instance_valid(player):
		position = -player.global_position
