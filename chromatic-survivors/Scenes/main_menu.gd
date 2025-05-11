extends Node2D
@export var controls_scene: PackedScene

func _process(delta: float) -> void:
		if(Input.is_action_just_released("p1_start")):
			get_tree().change_scene_to_packed(controls_scene)
		if(Input.is_action_just_released("p1_select")):	
			get_tree().quit()
