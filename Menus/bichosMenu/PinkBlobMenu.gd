extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.get_animation("Idle").loop=true
	$AnimationPlayer.play("Idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	if int(rand_range(0,10))>5:
		$AnimationPlayer.play("Walk")
	else:
		$AnimationPlayer.play("Jump")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name=="Walk" or anim_name=="Jump":
		$AnimationPlayer.play("Idle")
