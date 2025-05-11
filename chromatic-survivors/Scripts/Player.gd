extends CharacterBody2D

enum LightColour {RED, BLUE, YELLOW}

@export var speed : int = 150
@export var brake : int = 15
@export var pickup : int = 50

var MAX_HEALTH = 100.0;
var CURRENT_HEALTH = 100.0;
var last_aim = Vector2.RIGHT
var damage_rate = 50.0;

var light_damage_interval := 0.05  # seconds between hits
var light_damage_timer := 0.0
var light_damage_amount = 1;

var light_colour = LightColour.RED

signal player_is_dead

var yellowLevel = ColorLevel.new()
var blueLevel = ColorLevel.new()
var redLevel = ColorLevel.new()

@onready var damage_fx_player = $DamageFxPlayer  # Or AudioStreamPlayer2D

@export var damageSounds: Array[AudioStream] = [
	preload("res://Sounds/player-damaged-sounds/spaceEngineLarge_000.ogg"),
	preload("res://Sounds/player-damaged-sounds/spaceEngineLarge_001.ogg"),
	preload("res://Sounds/player-damaged-sounds/spaceEngineLarge_002.ogg"),
	preload("res://Sounds/player-damaged-sounds/spaceEngineLarge_003.ogg"),
	preload("res://Sounds/player-damaged-sounds/spaceEngineLarge_004.ogg")
]

@onready var pickup_range: CollisionShape2D = $PickupRadius/Range
@onready var light_rotate: Node2D = $LightRotate
var DamageParticleScene = preload("res://player_particles.tscn")
var ExplosivePlayerScene = preload("res://explosive_player.tscn")

func playDamageSound():
	if damage_fx_player.playing:
		return  # Already playing, skip

	var chosen_stream = damageSounds[randi() % damageSounds.size()]
	damage_fx_player.stream = chosen_stream
	damage_fx_player.pitch_scale = randf_range(0.9, 1.1)
	damage_fx_player.volume_db = randf_range(-2, 0)
	damage_fx_player.play()
	
func stopDamageSound():
	if damage_fx_player.playing:
		damage_fx_player.stop()


func LevelUp() -> String:
	var rng = RandomNumberGenerator.new()
	rng.randomize()

	# Pick random color and feature enums
	var color_index = rng.randi_range(0, 2)
	var feature_index = rng.randi_range(0, 1)
	
	var rand_for_speed = rng.randi_range(0,5)
	var rand_for_pickup = rng.randi_range(0,5)
	
	if rand_for_speed == 5:
		speed += 50
		print("+ Speed!")
		return "+Speed!"
	
	if rand_for_pickup == 5:
		pickup += 10
		print("+ Pickup Range!")
		pickup_range.shape.radius = pickup; 
		return "+Pickup Range!"
	
	
	var result_text : String = ""
	
	var enumColorRandSelected : LightColour
	var colorSelected : ColorLevel
	
	if color_index == 0:
		result_text = "Yellow "
		colorSelected = yellowLevel
		enumColorRandSelected = LightColour.YELLOW
	elif color_index == 1:
		result_text = "Blue "
		colorSelected = blueLevel
		enumColorRandSelected = LightColour.BLUE
	elif color_index == 2:
		result_text = "Red "
		colorSelected = redLevel
		enumColorRandSelected = LightColour.RED
		
	if feature_index == 0:
		result_text += "+50 Radius!"
		colorSelected.radius += 50
	if feature_index == 1:
		result_text += "+1 Width!"
		colorSelected.segments += 1

	if light_colour == enumColorRandSelected:
		$LightRotate/LineCone.generate_cone(colorSelected)
	print(result_text)
	return result_text
	
	
	
func _ready() -> void:
	light_colour = LightColour.BLUE
	$LightRotate/LineCone/LightColor.color = GameColours.BLUE
	$Inside.modulate = GameColours.BLUE
	$LightRotate/LineCone/LightColor.color.a = 0.2
	$LightRotate/LineCone.generate_cone(blueLevel)
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
		$LightRotate/LineCone.generate_cone(blueLevel)
		
	if(Input.is_action_just_released("p1_color_red")):
		light_colour = LightColour.RED
		$LightRotate/LineCone/LightColor.color = GameColours.RED
		$Inside.modulate = GameColours.RED
		$LightRotate/LineCone.generate_cone(redLevel)
		
	if(Input.is_action_just_released("p1_color_yellow")):
		light_colour = LightColour.YELLOW
		$LightRotate/LineCone/LightColor.color = Color.YELLOW
		$Inside.modulate = Color.YELLOW
		$LightRotate/LineCone.generate_cone(yellowLevel)
	
	if (Input.is_action_just_pressed("p1_cycle_color_left")):
		if light_colour == LightColour.RED:
			light_colour = LightColour.BLUE
			$LightRotate/LineCone/LightColor.color = Color.BLUE
			$Inside.modulate = Color.BLUE
			$LightRotate/LineCone.generate_cone(blueLevel)
		elif light_colour == LightColour.YELLOW:
			light_colour = LightColour.RED
			$LightRotate/LineCone/LightColor.color = Color.RED
			$Inside.modulate = Color.RED
			$LightRotate/LineCone.generate_cone(redLevel)
		elif light_colour == LightColour.BLUE:
			light_colour = LightColour.YELLOW
			$LightRotate/LineCone/LightColor.color = Color.YELLOW
			$Inside.modulate = Color.YELLOW
			$LightRotate/LineCone.generate_cone(yellowLevel)
	if (Input.is_action_just_pressed("level_up"))	:
		LevelUp()
	if (Input.is_action_just_pressed("p1_cycle_color_right")):
		if light_colour == LightColour.RED:
			light_colour = LightColour.YELLOW
			$LightRotate/LineCone/LightColor.color = Color.YELLOW
			$Inside.modulate = Color.YELLOW
			$LightRotate/LineCone.generate_cone(yellowLevel)
		elif light_colour == LightColour.YELLOW:
			light_colour = LightColour.BLUE
			$LightRotate/LineCone/LightColor.color = Color.BLUE
			$Inside.modulate = Color.BLUE
			$LightRotate/LineCone.generate_cone(blueLevel)
		elif light_colour == LightColour.BLUE:
			light_colour = LightColour.RED
			$LightRotate/LineCone/LightColor.color = Color.RED
			$Inside.modulate = Color.RED
			$LightRotate/LineCone.generate_cone(redLevel)
			
	$LightRotate/LineCone/LightColor.color.a = 0.2
	velocity = direction * speed;

	move_and_slide()
	
	var enemies_colliding = $Hurtbox.get_overlapping_bodies()
	if enemies_colliding.size() > 0:
		CURRENT_HEALTH -= damage_rate * delta * enemies_colliding.size()
		CURRENT_HEALTH = max(CURRENT_HEALTH, 0)
		playDamageSound()
		# Trigger white damage particles
		spawn_damage_particles()
		
	else:
		stopDamageSound()
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


func _on_pickup_radius_body_entered(body: Node2D) -> void:
	body.get_parent().target = self; #based on layers this should only be items.
