extends Camera2D

@export var target: Node2D = null

func _process(_delta):
	if is_instance_valid(target):
		global_position = target.global_position
