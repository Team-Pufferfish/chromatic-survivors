extends CharacterBody2D

enum LightColour {RED, BLUE, YELLOW}

@onready var player = get_node("/root/Game/Player")

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
		queue_free()
	
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
		return Color.SADDLE_BROWN
	if has_red and has_blue:
		return Color.WEB_PURPLE
	if has_red and has_yellow:
		return Color.ORANGE
	if has_yellow and has_blue:
		return Color.GREEN
	if has_red:
		return Color.RED
	if has_blue:
		return Color.BLUE
	if has_yellow:
		return Color.YELLOW
	return Color.WHITE

func set_particle_colour(colour: int) -> void:
	match colour:
		LightColour.RED:
			$DamageParticles.modulate = Color.RED
		LightColour.BLUE:
			$DamageParticles.modulate = Color.BLUE
		LightColour.YELLOW:
			$DamageParticles.modulate = Color.YELLOW
	
func trigger_damage_particles(from_direction: Vector2, colour: int) -> void:
	var particles = $DamageParticles
	if particles:
		var particle_direction = from_direction.normalized()
		particles.rotation = particle_direction.angle()
		set_particle_colour(colour)
		particles.restart()
