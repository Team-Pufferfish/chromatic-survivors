extends Node2D

@onready var spawn_timer = $SpawnTimer
@export var thing_to_spawn: PackedScene
@export var divider : int = 2
func _ready():
	spawn_timer.start()  # Just to be sure

func _on_spawn_timer_timeout():
	spawn_thing()

func spawn_thing():
	var instance = thing_to_spawn.instantiate()
	
	instance.speed = 200
	instance.CURRENT_BLUE = get_parent().CURRENT_BLUE / divider;
	instance.CURRENT_RED = get_parent().CURRENT_RED / divider;
	instance.CURRENT_YELLOW = get_parent().CURRENT_YELLOW / divider;
	
	instance.MAX_BLUE = get_parent().MAX_BLUE / divider;
	instance.MAX_RED = get_parent().MAX_RED / divider;
	instance.MAX_YELLOW = get_parent().MAX_YELLOW / divider;
	
	get_parent().add_sibling(instance)
	
	var radius = 20  # max distance from parent
	var angle = randf() * TAU  # TAU = 2π, full circle
	var offset = Vector2(cos(angle), sin(angle)) * randf_range(0, radius)

	instance.global_position = global_position + offset
