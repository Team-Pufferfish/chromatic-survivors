extends Node2D

enum LightColour {RED, BLUE, YELLOW}

var red_loot = 0;
var blue_loot = 0;
var yellow_loot = 0;
var total_loot = 0;

@onready var player: CharacterBody2D = $Player
var player_alive = true

@onready var red: Label = $CanvasLayer/Totals/Red
@onready var blue: Label = $CanvasLayer/Totals/Blue
@onready var total: Label = $CanvasLayer/Totals/Total
@onready var yellow: Label = $CanvasLayer/Totals/Yellow
@onready var level_bar: ProgressBar = $CanvasLayer/LevelBar
@onready var game_over: Label = $CanvasLayer/GameOver
@onready var totals: HBoxContainer = $CanvasLayer/Totals
@onready var level_bonus: Label = $CanvasLayer/LevelBonus
@onready var instructions: Label = $CanvasLayer/Instructions

var time_elapsed := 0.0
@onready var time_label: Label = $CanvasLayer/TimeLabel  # Add a label in your scene to show the time

var next_level_required = 10;
var last_level = 0

func _ready() -> void:
	level_bar.max_value = next_level_required

func _on_player_player_is_dead() -> void:
	$GameOverExplosionPlayer.play()
	game_over.show()
	totals.show()
	instructions.show()
	player_alive = false

func _on_enemy_died() -> void:
	$DeadEnemyPlayer.play()
	

func _on_loot_get(colour: LightColour) -> void:
	$CoinCollectPlayer.play()
	if(colour == LightColour.RED):
		red_loot += 1
	if(colour == LightColour.BLUE):
		blue_loot += 1
	if(colour == LightColour.YELLOW):
		yellow_loot += 1
	total_loot += 1
	
	red.text = "Red " + str(red_loot)
	blue.text = "Blue " + str(blue_loot)
	yellow.text = "Yellow " + str(yellow_loot)
	total.text = "Total " + str(total_loot)
	level_bar.value = total_loot - last_level
	
	if(total_loot >= next_level_required):
		print("Level up :" + str(total_loot) + "/" + str(next_level_required))
		last_level = next_level_required
		next_level_required = next_level_required + 10
		level_bar.max_value = next_level_required - last_level
		level_bar.value = total_loot - last_level
		var level_up_bonus = player.LevelUp()
		level_bonus.show_message(level_up_bonus)
		
func _process(delta: float) -> void:
	if is_instance_valid(player):
		time_elapsed += delta
		var minutes = int(time_elapsed) / 60
		var seconds = int(time_elapsed) % 60
		time_label.text = "%02d:%02d" % [minutes, seconds]
	if(!player_alive):
		if(Input.is_action_just_released("p1_start")):
			get_tree().reload_current_scene()
		if(Input.is_action_just_released("p1_select")):	
			get_tree().quit()
	
func _on_heal_player() -> void:
	if (is_instance_valid(player)):
		level_bonus.show_message("Healed!")
		$HealCollectPlayer.play()
		player.CURRENT_HEALTH = player.MAX_HEALTH
