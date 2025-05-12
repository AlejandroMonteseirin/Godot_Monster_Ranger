extends Spatial

var radio=1
var ataque=5
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var vectorMovimiento=Vector3(5,0,0)

func _process(delta):
	self.global_transform.origin=self.global_transform.origin+vectorMovimiento*delta
	$MeshInstance.rotate(Vector3(1,0,0),0.5)

func _on_Timer_timeout():
	if(self.global_transform.origin.distance_to(Vector3(0,0,0))>25):
		queue_free()
