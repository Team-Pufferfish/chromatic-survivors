extends CharacterBody2D

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
	
func _process(_delta: float) -> void:
	if MAX_BLUE > 0:
		$Polygon2D.color.b = CURRENT_BLUE/MAX_BLUE
	if MAX_YELLOW > 0:
		$Polygon2D.color.g = CURRENT_YELLOW/MAX_YELLOW
	if MAX_RED > 0:
		$Polygon2D.color.r = CURRENT_RED/MAX_RED
	
