extends Node2D

var tick_timer := 0.0

var max_aura_red: float
var max_aura_blue: float
var max_aura_yellow: float

@export var tick_rate := 1.0  # seconds between aura ticks
@export var aura_strength := 2  # amount to heal per tick

@onready var parent_enemy := get_parent()
@onready var area: Area2D = $EffectArea
@onready var aura_graphic = $AuraGraphic

func _ready() -> void:
	# Cache the parent's max aura values
	max_aura_red = parent_enemy.MAX_RED
	max_aura_blue = parent_enemy.MAX_BLUE
	max_aura_yellow = parent_enemy.MAX_YELLOW
	
		# Determine color
	var color := Color.WHITE
	if max_aura_red > 0 and max_aura_blue > 0 and max_aura_yellow > 0:
		color = Color.SADDLE_BROWN
	elif max_aura_red > 0 and max_aura_blue > 0:
		color = Color.MAGENTA
	elif max_aura_red > 0 and max_aura_yellow > 0:
		color = Color.ORANGE
	elif max_aura_blue > 0 and max_aura_yellow > 0:
		color = Color.GREEN
	elif max_aura_red > 0:
		color = Color.RED
	elif max_aura_blue > 0:
		color = Color.BLUE
	elif max_aura_yellow > 0:
		color = Color.YELLOW

	color.a = 0.5  # Set transparency
	aura_graphic.modulate = color

func _physics_process(delta: float) -> void:
	tick_timer += delta
	if tick_timer >= tick_rate:
		tick_timer = 0.0
		apply_aura_to_nearby_enemies()
		
func apply_aura_to_nearby_enemies() -> void:
	var bodies = area.get_overlapping_bodies()
	for body in bodies:
		if body == parent_enemy:
			continue  # skip self

		if(max_aura_red != 0):
			if(body.MAX_RED < max_aura_red):
				body.MAX_RED = max_aura_red
			body.CURRENT_RED = min(body.CURRENT_RED + aura_strength, body.MAX_RED)
		
		if(max_aura_blue != 0):
			if(body.MAX_BLUE < max_aura_blue):
				body.MAX_BLUE = max_aura_blue
			body.CURRENT_BLUE = min(body.CURRENT_BLUE + aura_strength, body.MAX_BLUE)

		if(max_aura_yellow != 0):
			if(body.MAX_YELLOW < max_aura_yellow):
				body.MAX_YELLOW = max_aura_yellow
			body.CURRENT_YELLOW = min(body.CURRENT_YELLOW + aura_strength, body.MAX_YELLOW)
