extends Label

@export var fade_duration := 2.5  # seconds

var fade_timer := 0.0
var fading := false

func _ready():
	modulate.a = 0.0  # start invisible

func show_message(text: String):
	self.text = text
	modulate.a = 1.0
	visible = true
	fade_timer = 0.0
	fading = true

func _process(delta):
	if fading:
		fade_timer += delta
		var progress = fade_timer / fade_duration
		modulate.a = 1.0 - clamp(progress, 0.0, 1.0)

		if fade_timer >= fade_duration:
			fading = false
			visible = false
