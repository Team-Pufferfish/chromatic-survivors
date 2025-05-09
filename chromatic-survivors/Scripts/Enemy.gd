extends CharacterBody2D

enum LightColour {RED, BLUE, YELLOW}

@onready var player = get_node("/root/Game/Player")
const DamageParticleScene = preload("res://damage_particles.tscn")
const EnemyExplosionScene = preload("res://explosive_enemy.tscn")
const LootScene = preload("res://Scenes/loot.tscn")

@export var speed : int = 75

@export var MAX_BLUE : float 
@export var CURRENT_BLUE : float 

@export var MAX_RED : float 
@export var CURRENT_RED : float 

##@export var MAX_GREEN : int 
#@export var CURRENT_GREEN : int 

@export var MAX_YELLOW : float 
@export var CURRENT_YELLOW : float 

func _physics_process(_delta: float) -> void:
	if is_instance_valid(player):
		var player_direction = global_position.direction_to(player.global_position)
		velocity = player_direction * speed
	
	move_and_slide()
	
func deal_damage(colour: int, amount: int, source_direction: Vector2 = Vector2.ZERO) -> void:
	var damaged := false
	
	match colour:
		LightColour.RED:
			if CURRENT_RED > 0:
				CURRENT_RED = max(CURRENT_RED - amount, 0)
				damaged = true
		LightColour.BLUE:
			if CURRENT_BLUE > 0:
				CURRENT_BLUE = max(CURRENT_BLUE - amount, 0)
				damaged = true
		LightColour.YELLOW:
			if CURRENT_YELLOW > 0:
				CURRENT_YELLOW = max(CURRENT_YELLOW - amount, 0)
				damaged = true

	if damaged and source_direction != Vector2.ZERO:
		trigger_damage_particles(source_direction, colour)
	
	if CURRENT_RED <= 0 and CURRENT_BLUE <= 0 and CURRENT_YELLOW <= 0:
		spawn_explosion(colour)
		maybe_spawn_loot(colour)
		queue_free()

func maybe_spawn_loot(colour:int):
	if randi() % 2 == 0:  # 50% chance
		var loot = LootScene.instantiate()
		var part_colour = GameColours.WHITE
		match colour:
			LightColour.RED:
				part_colour = GameColours.RED
			LightColour.BLUE:
				part_colour = GameColours.BLUE
			LightColour.YELLOW:
				part_colour = GameColours.YELLOW
		loot.modulate = part_colour
		loot.global_position = global_position
		get_tree().current_scene.add_child(loot)
		
func spawn_explosion(color: int) -> void:
	var part_colour = GameColours.WHITE
	match color:
		LightColour.RED:
			part_colour = GameColours.RED
		LightColour.BLUE:
			part_colour = GameColours.BLUE
		LightColour.YELLOW:
			part_colour = GameColours.YELLOW
	var explosion = EnemyExplosionScene.instantiate()
	explosion.global_position = global_position
	explosion.modulate = part_colour  # Apply color tint
	get_tree().current_scene.add_child(explosion)
	
func _process(_delta: float) -> void:
	$Graphic.yellow_value = CURRENT_YELLOW / max(MAX_YELLOW,1)
	$Graphic.blue_value = CURRENT_BLUE / max(MAX_BLUE,1)
	$Graphic.red_value = CURRENT_RED / max(MAX_RED,1)
	#$Polygon2D.color = get_color_from_stats()

func get_color_from_stats() -> Color:
	var has_red = MAX_RED > 0
	var has_blue = MAX_BLUE > 0
	var has_yellow = MAX_YELLOW > 0

	if has_red and has_blue and has_yellow:
		return GameColours.BROWN
	if has_red and has_blue:
		return GameColours.PURPLE
	if has_red and has_yellow:
		return GameColours.YELLOW
	if has_yellow and has_blue:
		return GameColours.BLUE
	if has_red:
		return GameColours.RED
	if has_blue:
		return GameColours.BLUE
	if has_yellow:
		return GameColours.YELLOW
	return GameColours.WHITE
	
func trigger_damage_particles(from_direction: Vector2, colour: int) -> void:
	var particles = DamageParticleScene.instantiate()
	particles.global_position = global_position
	
	# Set color based on damage type
	match colour:
		LightColour.RED:
			particles.modulate = GameColours.RED
		LightColour.BLUE:
			particles.modulate = GameColours.BLUE
		LightColour.YELLOW:
			particles.modulate = GameColours.YELLOW
	
	# Optional: rotate in direction of damage
	particles.rotation = from_direction.normalized().angle()
	get_tree().current_scene.add_child(particles)
