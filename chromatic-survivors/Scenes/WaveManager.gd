extends Node

@export var enemy_spawner_path: NodePath
@export var wave_interval: float = 30.0  # Seconds between waves

var current_wave_index := 0
var wave_timer := 0.0
var enemy_spawner  # Reference to your existing spawner node
var waves = []  # Populated in _ready or externally

func _ready():
	enemy_spawner = get_node(enemy_spawner_path)
	setup_waves()

func _process(delta):
	wave_timer += delta
	if wave_timer >= wave_interval:
		wave_timer = 0.0
		advance_wave()

func setup_waves():
	waves = [
		{
			"spawn_rate": 2.0,
			"max_enemies": 20,
			"enemies": [
				{ "red": 0, "yellow": 0, "blue": 10, "speed": 60, "chance": 1.0 },
			]
		},
		{
			"spawn_rate": 1.5,
			"max_enemies": 40,
			"enemies": [
				{ "red": 20, "yellow": 0, "blue": 0, "speed": 100, "chance": 0.7 },
				{ "red": 0,  "yellow": 30, "blue": 0, "speed": 70, "chance": 0.3 },
			]
		},
		{
			"spawn_rate": 1.0,
			"max_enemies": 75,
			"enemies": [
				{ "red": 20, "yellow": 0, "blue": 20, "speed": 80, "chance": 0.5 },
				{ "red": 0,  "yellow": 30, "blue": 10, "speed": 60, "chance": 0.5 },
			]
		},
				{
			"spawn_rate": 0.25,
			"max_enemies": 100,
			"enemies": [
				{ "red": 50,  "yellow": 0, "blue": 0, "speed": 100, "chance": 0.1 },
				{ "red": 0,  "yellow": 75, "blue": 0, "speed": 75, "chance": 0.1 },
				{ "red": 0,  "yellow": 0, "blue": 50, "speed": 50, "chance": 0.1 },
				{ "red": 50,  "yellow": 75, "blue": 0, "speed": 100, "chance": 0.2 },
				{ "red": 50,  "yellow": 0, "blue": 50, "speed": 65, "chance": 0.2 },
				{ "red": 0,  "yellow": 75, "blue": 50, "speed": 75, "chance": 0.2 },
			]
		},
	]

	advance_wave()

func advance_wave():
	print("ADVANCING WAVE")
	if current_wave_index >= waves.size():
		print("All waves completed")
		return

	var wave = waves[current_wave_index]
	current_wave_index += 1

	enemy_spawner.set_wave_config(wave.enemies)
	enemy_spawner.spawn_rate = wave.spawn_rate
	enemy_spawner.max_enemies = wave.max_enemies
