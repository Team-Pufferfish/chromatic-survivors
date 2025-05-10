extends CharacterBody2D

enum LightColour {RED, BLUE, YELLOW}

@export var speed : int = 300
@export var brake : int = 15

var MAX_HEALTH = 100.0;
var CURRENT_HEALTH = 100.0;
var last_aim = Vector2.RIGHT
var damage_rate = 2.0;

var light_damage_interval := 0.25  # seconds between hits
var light_damage_timer := 0.0
var light_damage_amount = 2;

var light_colour = LightColour.RED

signal player_is_dead

@onready var light_rotate: Node2D = $LightRotate

func _ready() -> void:
	$Graphic.fill = 1

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("p1_left", "p1_right","p1_up","p1_down");
	
	var aim_direction = Input.get_vector("p1_aim_left","p1_aim_right","p1_aim_up","p1_aim_down")
	
	if (aim_direction.length() > 0):
		last_aim = aim_direction

	light_rotate.rotation = last_aim.angle()
	
	if(Input.is_action_just_released("p1_color_blue")):
		light_colour = LightColour.BLUE
		$LightRotate/LineCone/LightColor.color = Color.BLUE
		
	if(Input.is_action_just_released("p1_color_red")):
		light_colour = LightColour.RED
		$LightRotate/LineCone/LightColor.color = Color.RED
	if(Input.is_action_just_released("p1_color_yellow")):
		light_colour = LightColour.YELLOW
		$LightRotate/LineCone/LightColor.color = Color.YELLOW
	$LightRotate/LineCone/LightColor.color.a = 0.5
	
	velocity = direction * speed;

	move_and_slide()
	
	var enemies_colliding = $Hurtbox.get_overlapping_bodies()
	if enemies_colliding.size() > 0:
		CURRENT_HEALTH -= damage_rate * enemies_colliding.size()
		CURRENT_HEALTH = max(CURRENT_HEALTH, 0)
		$Graphic.fill = CURRENT_HEALTH / MAX_HEALTH
		
	if CURRENT_HEALTH <= 0:
		emit_signal("player_is_dead")
	
	# Update damage timer
	light_damage_timer += delta
	if light_damage_timer >= light_damage_interval:
		light_damage_timer = 0.0
		apply_light_cone_damage()
		
func apply_light_cone_damage() -> void:
	var enemies_in_light_cone = $LightRotate/LineCone.get_overlapping_bodies()
	for enemy in enemies_in_light_cone:
		var to_enemy = enemy.global_position - global_position
		enemy.deal_damage(light_colour, light_damage_amount,to_enemy)  # Example damage amount
