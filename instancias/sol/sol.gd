extends DirectionalLight


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
var time=0
var angulo=-60
func _process(delta):
	time=time+delta
	if(time>0.3):
		self.rotation_degrees[1]=-angulo
		if angulo>90:
			self.light_energy=0
		else:
			if(angulo<0):
				self.light_energy=  0.02222*angulo + 2
			else:
				self.light_energy=  -0.02222*angulo + 2
		angulo=angulo+1
		if(angulo==180):
			angulo=-90
		time=0

		
	
