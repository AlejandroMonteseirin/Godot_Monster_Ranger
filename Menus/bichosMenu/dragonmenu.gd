extends StaticBody


func _ready():
	$AnimationPlayer.get_animation("Flying_Idle").loop=true
	$AnimationPlayer.play("Flying_Idle")



