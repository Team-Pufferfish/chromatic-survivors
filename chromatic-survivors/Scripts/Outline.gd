extends Line2D

func _ready():
	# Define a square from (-0.5, -0.5) to (0.5, 0.5)
	points = [
		Vector2(-0.55, 0.55),
		Vector2(0.55, 0.55),
		Vector2(0.55, -0.55),
		Vector2(-0.55, -0.55),
		Vector2(-0.55, 0.6)  # Close the loop
	]
	
