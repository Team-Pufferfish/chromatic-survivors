extends CharacterBody2D

@export var speed : int = 300
@export var brake : int = 15

var MAX_HEALTH = 100;
var CURRENT_HEALTH = 100;
var last_aim = Vector2.RIGHT

@onready var light_rotate: Node2D = $LightRotate

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("p1_left", "p1_right","p1_up","p1_down");
	
	var aim_direction = Input.get_vector("p1_aim_left","p1_aim_right","p1_aim_up","p1_aim_down")
	
	if (aim_direction.length() > 0):
		last_aim = aim_direction

	light_rotate.rotation = last_aim.angle()
	
	velocity = direction * speed;

	move_and_slide()
	
