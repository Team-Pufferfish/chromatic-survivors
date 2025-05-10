extends Node2D

var tick_timer := 0.0

var max_aura_red: float
var max_aura_blue: float
var max_aura_yellow: float

@export var tick_rate := 1.0  # seconds between aura ticks
@export var aura_strength := 2  # amount to heal per tick

@onready var parent_enemy := get_parent()
@onready var area: Area2D = $EffectArea


func _physics_process(delta: float) -> void:
		apply_aura_to_nearby_enemies()
		
func apply_aura_to_nearby_enemies() -> void:
	var bodies = area.get_overlapping_bodies()
	for body in bodies:
		if  body != parent_enemy and body.is_in_group("ShieldGuy"):
			parent_enemy.MAX_BLUE += body.MAX_BLUE
			parent_enemy.MAX_YELLOW += body.MAX_YELLOW
			parent_enemy.MAX_RED += body.MAX_RED
			parent_enemy.CURRENT_BLUE += body.CURRENT_BLUE
			parent_enemy.CURRENT_RED += body.CURRENT_RED
			parent_enemy.CURRENT_YELLOW += body.CURRENT_YELLOW
			parent_enemy.scale = parent_enemy.scale * 1.5
			body.free()
			
			
