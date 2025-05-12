extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var nivelInfo={}
var nivelId=0
var stars=0
# Called when the node enters the scene tree for the first time.
func _ready():
	match stars:
		1:
			$star1.modulate=Color(1,1,1)
		2:
			$star1.modulate=Color(1,1,1)
			$star2.modulate=Color(1,1,1)
		3:
			$star1.modulate=Color(1,1,1)
			$star2.modulate=Color(1,1,1)
			$star3.modulate=Color(1,1,1)
			
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
var escena = preload("res://Maps/Demo.tscn")



func _on_levelButton_pressed():
	print("nivel "+str(nivelId)+" elegido. Info level:")
	var nivel = escena.instance()
	nivel.nivelInfo=nivelInfo
	nivel.nivelId=nivelId
	var odin=get_tree().get_root().get_node("odin")
	odin.add_child(nivel)
	odin.remove_child(odin.get_node("main"))
	print(nivelInfo)
	print(nivel)

