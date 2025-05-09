extends CharacterBody2D

enum LightColour {RED, BLUE, YELLOW}

@onready var player = get_node("/root/Game/Player")

@export var speed : int = 75

@export var MAX_BLUE : int 
@export var CURRENT_BLUE : int 

@export var MAX_RED : int 
@export var CURRENT_RED : int 

##@export var MAX_GREEN : int 
#@export var CURRENT_GREEN : int 

@export var MAX_YELLOW : int 
@export var CURRENT_YELLOW : int 

func _physics_process(_delta: float) -> void:
	var player_direction = global_position.direction_to(player.global_position)
	velocity = player_direction * speed
	
	move_and_slide()
	
func deal_damage(colour: LightColour, amount: int) -> void:
	match colour:
		LightColour.RED:
			CURRENT_RED = max(CURRENT_RED - amount, 0)
		LightColour.BLUE:
			CURRENT_BLUE = max(CURRENT_BLUE - amount, 0)
		LightColour.YELLOW:
			CURRENT_YELLOW = max(CURRENT_YELLOW - amount, 0)
	
	# Check if enemy is dead
	if CURRENT_RED <= 0 and CURRENT_BLUE <= 0 and CURRENT_YELLOW <= 0:
		queue_free()
	
func _process(_delta: float) -> void:
	$Polygon2D.color = get_color_from_stats()

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
	
