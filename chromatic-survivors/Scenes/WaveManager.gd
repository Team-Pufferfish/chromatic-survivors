extends Node

enum EnemyType { SQUARE, STAR, HEX, TRIANGLE }

@export var enemy_spawner_path: NodePath
@export var wave_interval: float = 30.0  # Seconds between waves

var current_wave_index := 0
var wave_timer := 0.0
var enemy_spawner  # Reference to your existing spawner node
var waves = []  # Populated in _ready or externally

signal wave_started
signal boss_spawned

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
			"max_enemies": 10,
			"boss": { "type": EnemyType.STAR, "red": 20, "yellow": 0, "blue": 0, "speed": 100, "chance": 1.0 },
			"enemies": [
				{"type": EnemyType.SQUARE, "red": 0, "yellow": 0, "blue": 10, "speed": 50, "chance": 1.0 },
			]
		},
		{
			"spawn_rate": 1.5,
			"max_enemies": 25,
			"enemies": [
				{ "type": EnemyType.SQUARE, "red": 10, "yellow": 0, "blue": 0, "speed": 100, "chance": 0.7 },
				{ "type": EnemyType.SQUARE, "red": 0,  "yellow": 15, "blue": 0, "speed": 75, "chance": 0.3 },
			]
		},
				{
			"spawn_rate": 1.5,
			"max_enemies": 30,
			"enemies": [
				{"type": EnemyType.SQUARE,  "red": 10, "yellow": 0, "blue": 0, "speed": 100, "chance": 0.3 },
				{ "type": EnemyType.SQUARE, "red": 0,  "yellow": 15, "blue": 0, "speed": 75, "chance": 0.3 },
				{"type": EnemyType.SQUARE,  "red": 0,  "yellow": 0, "blue": 10, "speed": 50, "chance": 0.3 }
			]
		},
		{
			"spawn_rate": 1.5,
			"max_enemies": 35,
			"enemies": [
				{ "type": EnemyType.SQUARE, "red": 10, "yellow": 15, "blue": 0, "speed": 87, "chance": 1.0 },

			]
		},
		{
			"spawn_rate": 1.25,
			"max_enemies": 40,
			"boss": { "type": EnemyType.STAR, "red": 20, "yellow": 0, "blue": 0, "speed": 100, "chance": 1.0 },
			"enemies": [
				{"type": EnemyType.SQUARE,  "red": 0, "yellow": 15, "blue": 0, "speed": 75, "chance": 1.0 },
			]
		},
		{
			"spawn_rate": 1.25, #yellow and green
			"max_enemies": 45,
			"enemies": [
				{"type": EnemyType.SQUARE, "red": 0, "yellow": 0, "blue": 10, "speed": 50, "chance": 0.5 },
				{"type": EnemyType.SQUARE, "red": 0,  "yellow": 15, "blue": 10, "speed": 62, "chance": 0.5 },
			]
		},
		{
			"spawn_rate": 1.25, #yllow start + red/blue
			"max_enemies": 50,
			"boss": { "type": EnemyType.STAR, "red": 0, "yellow": 25, "blue": 0, "speed": 75, "chance": 1.0 },
			"enemies": [
				{"type": EnemyType.SQUARE, "red": 10, "yellow": 0, "blue": 0, "speed": 100, "chance": 0.5 },
				{"type": EnemyType.SQUARE, "red": 0,  "yellow": 0, "blue": 10, "speed": 50, "chance": 0.5 }
			]
		},
		{
			"spawn_rate": 1.25,
			"max_enemies": 55,
			"enemies": [
				{"type": EnemyType.SQUARE, "red": 10, "yellow": 0, "blue": 10, "speed": 75, "chance": 0.3 },
				{ "type": EnemyType.SQUARE,"red": 0,  "yellow": 15, "blue": 10, "speed": 50, "chance": 0.3 }
			]
		},
		{
			"spawn_rate": 1.0,
			"max_enemies": 60,
			"boss": { "type": EnemyType.SQUARE, "red": 10, "yellow": 15, "blue": 10, "speed": 75, "chance": 1.0 },
			"enemies": [
				{"type": EnemyType.SQUARE, "red": 10, "yellow": 0, "blue": 0, "speed": 100, "chance": 0.3 },
				{"type": EnemyType.SQUARE, "red": 0,  "yellow": 15, "blue": 0, "speed": 75, "chance": 0.3 },
				{ "type": EnemyType.SQUARE,"red": 0,  "yellow": 0, "blue": 10, "speed": 50, "chance": 0.3 }
			]
		},		
		{
			"spawn_rate": 1.0,
			"max_enemies": 65,
			"boss": {"type": EnemyType.STAR, "red": 0, "yellow": 25, "blue": 20, "speed": 75, "chance": 1.0 },
			"enemies": [
				{"type": EnemyType.SQUARE, "red": 10, "yellow": 0, "blue": 0, "speed": 100, "chance": 0.3 },
				{"type": EnemyType.SQUARE, "red": 0,  "yellow": 15, "blue": 0, "speed": 75, "chance": 0.3 },
				{"type": EnemyType.SQUARE, "red": 0,  "yellow": 0, "blue": 10, "speed": 50, "chance": 0.3 }
			]
		},
				{
			"spawn_rate": 1.0,
			"max_enemies": 100,
			"boss": {"type": EnemyType.STAR, "red": 25, "yellow": 25, "blue": 25, "speed": 75, "chance": 1.0 },
			"enemies": [
				{"type": EnemyType.SQUARE, "red": 50,  "yellow": 50, "blue": 50, "speed": 100, "chance": 1.0 },
			]
		},
	]

	advance_wave()

func advance_wave():
	print("ADVANCING WAVE")
	emit_signal("wave_started")
	if current_wave_index >= waves.size():
		print("All waves completed")
		return

	var wave = waves[current_wave_index]
	current_wave_index += 1

	enemy_spawner.set_wave_config(wave.enemies)
	enemy_spawner.spawn_rate = wave.spawn_rate
	enemy_spawner.max_enemies = wave.max_enemies
	
	if wave.has("boss"):	
		print("BOSS APPEARS")
		emit_signal("boss_spawned")
		enemy_spawner.spawn_boss(wave.boss)
