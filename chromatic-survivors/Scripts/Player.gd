extends CharacterBody2D

@export var speed : int = 300
@export var brake : int = 15

var MAX_HEALTH = 100.0;
var CURRENT_HEALTH = 100.0;
var last_aim = Vector2.RIGHT
var damage_rate = 2.0;

signal player_is_dead

@onready var light_rotate: Node2D = $LightRotate

func _ready() -> void:
	$HealthBar.value = CURRENT_HEALTH

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("p1_left", "p1_right","p1_up","p1_down");
	
	var aim_direction = Input.get_vector("p1_aim_left","p1_aim_right","p1_aim_up","p1_aim_down")
	
	if (aim_direction.length() > 0):
		last_aim = aim_direction

	light_rotate.rotation = last_aim.angle()
	
	velocity = direction * speed;

	move_and_slide()
	
	var enemies_colliding = $Hurtbox.get_overlapping_bodies()
	if enemies_colliding.size() > 0:
		CURRENT_HEALTH -= damage_rate * enemies_colliding.size()
		$HealthBar.value = CURRENT_HEALTH
		
	if CURRENT_HEALTH <= 0:
		emit_signal("player_is_dead")
		print("player is dead")
		
	var enemies_in_light_cone = $LightRotate/LineCone.get_overlapping_bodies()
	if enemies_in_light_cone.size() > 0:
		print(enemies_in_light_cone.size())
		
	
	
