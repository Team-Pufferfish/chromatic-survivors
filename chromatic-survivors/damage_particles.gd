extends GPUParticles2D

func _ready():
	await get_tree().create_timer(lifetime).timeout
	queue_free()
