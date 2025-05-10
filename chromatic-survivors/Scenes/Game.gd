extends Node2D

enum LightColour {RED, BLUE, YELLOW}

var red_loot = 0;
var blue_loot = 0;
var yellow_loot = 0;
var total_loot = 0;

@onready var player: CharacterBody2D = $Player

@onready var red: Label = $CanvasLayer/Totals/Red
@onready var blue: Label = $CanvasLayer/Totals/Blue
@onready var total: Label = $CanvasLayer/Totals/Total
@onready var yellow: Label = $CanvasLayer/Totals/Yellow
@onready var level_bar: ProgressBar = $CanvasLayer/LevelBar
@onready var game_over: Label = $CanvasLayer/GameOver
@onready var totals: HBoxContainer = $CanvasLayer/Totals

var next_level_required = 10;
var last_level = 0

func _ready() -> void:
	level_bar.max_value = next_level_required

func _on_player_player_is_dead() -> void:
	game_over.show()
	totals.show()

func _on_loot_get(colour: LightColour) -> void:
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
		print("LEvel up :" + str(total_loot) + "/" + str(next_level_required))
		last_level = next_level_required
		next_level_required = next_level_required + next_level_required * 1.2
		level_bar.max_value = next_level_required - last_level
		level_bar.value = total_loot - last_level
		#player.level_up()
		

func _on_heal_player() -> void:
	if (is_instance_valid(player)):
		player.CURRENT_HEALTH = min(player.CURRENT_HEALTH + 10, player.MAX_HEALTH)
