extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var radius = 5.0
var speed = -2
var angle = 0.0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass



func _process(delta):
	angle += speed * delta
	self.transform.origin = Vector3(radius * cos(angle), 2, radius * sin(angle))
