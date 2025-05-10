extends Sprite2D

@export var scroll_speed := 1.0
@export var player_path: NodePath

var player: Node2D

func _ready():
	player = get_node(player_path)

func _process(delta):
	if is_instance_valid(player):
		# Calculate how much the background should scroll
		var offset = player.global_position / texture.get_size()
		material.set_shader_parameter("scroll_offset", offset)
