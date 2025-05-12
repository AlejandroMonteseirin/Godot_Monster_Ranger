tool
extends MultiMeshInstance

export var extents := Vector2.ONE
export var spawn_outside_circle := false
export var radius := 12.0
export var character_path := NodePath()



func _enter_tree() -> void:
	connect("visibility_changed", self, "_on_WindGrass_visibility_changed")


func _ready() -> void:
	var rng := RandomNumberGenerator.new()
	rng.randomize()

	var theta := 0
	var increase := 1
	var center: Vector3 = get_parent().global_transform.origin


	for instance_index in multimesh.instance_count:


		var transform := Transform()
		
		var x: float
		var z: float
		if spawn_outside_circle:
			x = center.x + (radius + rng.randf_range(0, extents.x)) * cos(theta)
			z = center.z + (radius + rng.randf_range(0, extents.y)) * sin(theta)
			theta += increase
		else:
			x = rng.randf_range(-extents.x, extents.x)
			z = rng.randf_range(-extents.y, extents.y)
			
		transform.origin = Vector3(x, 0, z)
		transform.basis.y= Vector3(rng.randf_range(-0.5, 0.5), 1, rng.randf_range(-0.6, -0.9))
		multimesh.set_instance_transform(instance_index, transform)


func _on_WindGrass_visibility_changed() -> void:
	if visible:
		_ready()

