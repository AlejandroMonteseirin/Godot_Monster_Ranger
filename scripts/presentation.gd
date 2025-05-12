extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



var cameraPosition=Vector3(0,5,0)

func camera_presentation(monster):
	print("presentando")
	$Camera.projection=Camera.PROJECTION_PERSPECTIVE
	$Tween.interpolate_property($Camera, "translation",
		Vector3(0,5,0), Vector3(0,10,5), 3,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Camera, "rotation_degrees",
		Vector3(-90,0,0), Vector3(-90,25,0), 3,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func resetCamera():
	$Camera.global_transform.origin=Vector3(0,5,0)
	$Camera.projection=Camera.PROJECTION_ORTHOGONAL
	$Camera.rotation_degrees=Vector3(-90,0,0)
