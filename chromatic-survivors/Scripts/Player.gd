extends CharacterBody2D

enum LightColour {RED, BLUE, YELLOW}

@export var speed : int = 300
@export var brake : int = 15

var MAX_HEALTH = 100.0;
var CURRENT_HEALTH = 100.0;
var last_aim = Vector2.RIGHT
var damage_rate = 2.0;

var light_damage_interval := 0.05  # seconds between hits
var light_damage_timer := 0.0
var light_damage_amount = 1;

var light_colour = LightColour.RED

signal player_is_dead

@onready var light_rotate: Node2D = $LightRotate
var DamageParticleScene = preload("res://player_particles.tscn")
var ExplosivePlayerScene = preload("res://explosive_player.tscn")

enum colors { red, yellow, blue }

func _ready() -> void:
	light_colour = LightColour.BLUE
	$LightRotate/LineCone/LightColor.color = GameColours.BLUE
	$Inside.modulate = GameColours.BLUE
	$LightRotate/LineCone/LightColor.color.a = 0.5
	self.add_to_group("Player")

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("p1_left", "p1_right","p1_up","p1_down");
	
	var aim_direction = Input.get_vector("p1_aim_left","p1_aim_right","p1_aim_up","p1_aim_down")
	
	if (aim_direction.length() > 0):
		last_aim = aim_direction

	light_rotate.rotation = last_aim.angle()
	
	if(Input.is_action_just_released("p1_color_blue")):
		light_colour = LightColour.BLUE
		$LightRotate/LineCone/LightColor.color = GameColours.BLUE
		$Inside.modulate = GameColours.BLUE
		
	if(Input.is_action_just_released("p1_color_red")):
		light_colour = LightColour.RED
		$LightRotate/LineCone/LightColor.color = GameColours.RED
		$Inside.modulate = GameColours.RED
	if(Input.is_action_just_released("p1_color_yellow")):
		light_colour = LightColour.YELLOW
		$LightRotate/LineCone/LightColor.color = Color.YELLOW
		$Inside.modulate = Color.YELLOW
	
	if (Input.is_action_just_pressed("p1_cycle_color_left")):
		if light_colour == LightColour.RED:
			light_colour = LightColour.BLUE
			$LightRotate/LineCone/LightColor.color = Color.BLUE
			$Inside.modulate = Color.BLUE
		elif light_colour == LightColour.YELLOW:
			light_colour = LightColour.RED
			$LightRotate/LineCone/LightColor.color = Color.RED
			$Inside.modulate = Color.RED
		elif light_colour == LightColour.BLUE:
			light_colour = LightColour.YELLOW
			$LightRotate/LineCone/LightColor.color = Color.YELLOW
			$Inside.modulate = Color.YELLOW
			
	if (Input.is_action_just_pressed("p1_cycle_color_right")):
		if light_colour == LightColour.RED:
			light_colour = LightColour.YELLOW
			$LightRotate/LineCone/LightColor.color = Color.YELLOW
			$Inside.modulate = Color.YELLOW
		elif light_colour == LightColour.YELLOW:
			light_colour = LightColour.BLUE
			$LightRotate/LineCone/LightColor.color = Color.BLUE
			$Inside.modulate = Color.BLUE
		elif light_colour == LightColour.BLUE:
			light_colour = LightColour.RED
			$LightRotate/LineCone/LightColor.color = Color.RED
			$Inside.modulate = Color.RED
			
	$LightRotate/LineCone/LightColor.color.a = 0.5
	velocity = direction * speed;

	move_and_slide()
	
	var enemies_colliding = $Hurtbox.get_overlapping_bodies()
	if enemies_colliding.size() > 0:
		CURRENT_HEALTH -= damage_rate * enemies_colliding.size()
		CURRENT_HEALTH = max(CURRENT_HEALTH, 0)
		
		# Trigger white damage particles
		spawn_damage_particles()
	$Inside.scale = Vector2(CURRENT_HEALTH / MAX_HEALTH * 0.06,CURRENT_HEALTH / MAX_HEALTH * 0.06)
		
	if CURRENT_HEALTH <= 0:
		emit_signal("player_is_dead")
		spawn_explosive_player()
		queue_free()
	
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
		
func spawn_damage_particles() -> void:
	var particles = DamageParticleScene.instantiate()
	particles.modulate = GameColours.WHITE
	particles.global_position = global_position
	get_tree().current_scene.add_child(particles)
	particles.emitting = true
	
func spawn_explosive_player() -> void:
	var explosion = ExplosivePlayerScene.instantiate()
	explosion.global_position = global_position
	get_tree().current_scene.add_child(explosion)
