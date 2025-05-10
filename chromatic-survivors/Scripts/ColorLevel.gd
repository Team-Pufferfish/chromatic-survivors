class_name ColorLevel
extends Resource  # Or Object, depending on what you need

var segments : int
var radius: float
var strength: float

func _init(segments := 3, radius := 200, strength := 1):
	self.segments = segments
	self.radius = radius
	self.strength = strength
