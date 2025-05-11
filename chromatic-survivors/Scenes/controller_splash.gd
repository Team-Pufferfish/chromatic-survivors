extends Node2D

@export var main_game_scene: PackedScene
@export var fade_duration := 1.0
@export var wait_duration := 10.0

@onready var fade_rect: ColorRect = $CanvasLayer/FadeRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var has_started_fade := false

func _ready() -> void:
	fade_rect.color.a = 0.0
	await get_tree().create_timer(wait_duration).timeout
	if not has_started_fade:
		start_fade()

func _input(event: InputEvent) -> void:
	if not has_started_fade and (event.is_pressed() and not event is InputEventMouseMotion):
		start_fade()

func start_fade() -> void:
	has_started_fade = true
	animation_player.play("fade_out")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		get_tree().change_scene_to_packed(main_game_scene)
