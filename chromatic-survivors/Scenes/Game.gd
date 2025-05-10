extends Node2D

enum LightColour {RED, BLUE, YELLOW}

var red_loot = 0;
var blue_loot = 0;
var yellow_loot = 0;
var total_loot = 0;

@onready var red: Label = $CanvasLayer/VBoxContainer/Red
@onready var blue: Label = $CanvasLayer/VBoxContainer/Blue
@onready var total: Label = $CanvasLayer/VBoxContainer/Total
@onready var yellow: Label = $CanvasLayer/VBoxContainer/Yellow

func _on_player_player_is_dead() -> void:
	pass # Replace with function body.

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
		
