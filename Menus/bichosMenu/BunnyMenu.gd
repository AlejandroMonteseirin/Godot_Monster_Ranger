extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.get_animation("Idle").loop=true
	$AnimationPlayer.play("Wave")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	$AnimationPlayer.play("Wave")


func _on_AnimationPlayer_animation_finished(anim_name):
	if(anim_name=="Wave"):
		$AnimationPlayer.play("Idle")
