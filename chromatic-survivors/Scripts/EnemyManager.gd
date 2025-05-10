extends Node2D

# Adjustable variables
@export var spawn_radius: float = 300.0
@export var spawn_rate: float = 0.5 # seconds between spawns
@export var reposition_rate: float = 0.25 # seconds between reposition checks
@export var max_enemies: int = 100
@export var enemy_scene: PackedScene
@export var boss_scene: PackedScene
@export var player_path: NodePath

# Internal state
var spawn_timer := 0.0
var reposition_timer := 0.0
var player: Node2D
var current_wave_config = []
var current_spawn_radius

func set_wave_config(config):
	current_wave_config = config

func _ready():
	player = get_node(player_path)

func _process(delta):
	if !is_instance_valid(player):
		return
	# Update timers
	spawn_timer += delta
	reposition_timer += delta

	# 1. Spawn enemies based on spawn rate
	if spawn_timer >= spawn_rate:
		spawn_timer = 0.0
		spawn_enemy_if_possible()

	# 2. Reposition enemies more frequently than spawn
	if reposition_timer >= reposition_rate:
		reposition_timer = 0.0
		reposition_far_enemies()

func get_spawn_radius() -> float:
	var camera := get_viewport().get_camera_2d()
	if camera == null:
		push_warning("No Camera2D found.")
		return 500.0  # fallback

	var rect := get_viewport().get_visible_rect()
	var half_size := rect.size / 2.0
	return half_size.length()  # just outside screen corners

func spawn_enemy_if_possible():
	current_spawn_radius = get_spawn_radius()
	var current_enemies = get_tree().get_nodes_in_group("Enemies").size()
	if current_enemies >= max_enemies:
		return

	var enemy_data = choose_enemy_config()
	if enemy_data == null:
		return

	var enemy_instance = enemy_scene.instantiate()
	enemy_instance.global_position = get_weighted_random_point_on_circle(player.global_position, current_spawn_radius)

	# Apply the wave config
	enemy_instance.speed = enemy_data.speed
	enemy_instance.MAX_RED = enemy_data.red
	enemy_instance.CURRENT_RED = enemy_data.red
	enemy_instance.MAX_BLUE = enemy_data.blue
	enemy_instance.CURRENT_BLUE = enemy_data.blue
	enemy_instance.MAX_YELLOW = enemy_data.yellow
	enemy_instance.CURRENT_YELLOW = enemy_data.yellow

	get_tree().current_scene.add_child(enemy_instance)
	enemy_instance.add_to_group("Enemies")
	
func spawn_boss(stats: Dictionary) -> void:
	var boss_instance = boss_scene.instantiate()
	boss_instance.MAX_RED = stats.red
	boss_instance.CURRENT_RED = stats.red
	boss_instance.MAX_YELLOW = stats.yellow
	boss_instance.CURRENT_YELLOW = stats.yellow
	boss_instance.MAX_BLUE = stats.blue
	boss_instance.CURRENT_BLUE = stats.blue
	boss_instance.speed = stats.speed

	boss_instance.global_position = get_weighted_random_point_on_circle(player.global_position, current_spawn_radius)
	get_tree().current_scene.add_child(boss_instance)

func choose_enemy_config():
	var r = randf()
	var accum = 0.0
	for config in current_wave_config:
		accum += config.chance
		if r <= accum:
			return config
	return current_wave_config.back()  # fallback

# Function to check and reposition far enemies
func reposition_far_enemies():
	var current_spawn_radius = get_spawn_radius()
	var reposition_radius = current_spawn_radius * 1.1

	# 1. Check and reposition far enemies
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		if enemy.global_position.distance_to(player.global_position) > reposition_radius:
			var new_pos = get_weighted_random_point_on_circle(player.global_position, current_spawn_radius)
			enemy.global_position = new_pos
			#print("moved enemy")

# Function to get a random point on a circle around the player
func get_random_point_on_circle(center: Vector2, radius: float) -> Vector2:
	var angle = randf() * TAU
	return center + Vector2(cos(angle), sin(angle)) * radius
	

# Function to get a random point on a circle around the player, weighted in the direction of movement
func get_weighted_random_point_on_circle(center: Vector2, radius: float) -> Vector2:
	# Get the player's velocity directly
	var velocity = player.velocity

	# Normalize the direction to get a unit vector
	var direction = velocity.normalized()

	# Generate a random angle for base spawn point
	var angle = randf() * TAU
	
	var bias_factor = 2.0

	# Weight the angle based on the player's movement direction
	var weighted_angle = angle + direction.angle() * bias_factor

	# Calculate the weighted spawn position
	return center + Vector2(cos(weighted_angle), sin(weighted_angle)) * radius
