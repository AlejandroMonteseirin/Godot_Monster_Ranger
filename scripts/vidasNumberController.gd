extends Node

var image0 = load("res://Assets/numbers/0.png")
var image1 = load("res://Assets/numbers/1.png")
var image2 = load("res://Assets/numbers/2.png")
var image3 = load("res://Assets/numbers/3.png")
var image4 = load("res://Assets/numbers/4.png")
var image5 = load("res://Assets/numbers/5.png")
var image6 = load("res://Assets/numbers/6.png")
var image7 = load("res://Assets/numbers/7.png")
var image8 = load("res://Assets/numbers/8.png")
var image9 = load("res://Assets/numbers/9.png")
var numbers:Dictionary = {0:image0,1:image1,2:image2,3:image3,4:image4,5:image5,6:image6,7:image7,8:image8,9:image9}
func _ready():
	pass # Replace with function body.

func showVida(numero,posicion,unmetro):
	if(numero<0):
		print("error vida controller")
		return

	if(numero<10):
		$vida.texture= numbers[numero]
		$vida.visible=true
		$vida.position=posicion
		$Tween.interpolate_property($vida, "modulate", 
		  Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1.0, 
		  Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween.start()
	else:
		var decenas=int(numero/10)
		var unidades=numero%10
		print(decenas)
		$vidadecenas.texture= numbers[decenas]
		$vidadecenas.visible=true
		$vidadecenas.position=posicion+Vector2(-unmetro/2,0)
		$Tween.interpolate_property($vidadecenas, "modulate", 
		  Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1.0, 
		  Tween.TRANS_LINEAR, Tween.EASE_IN)

		
		$vida.texture= numbers[unidades]
		$vida.visible=true
		$vida.position=posicion
		$Tween.interpolate_property($vida, "modulate", 
		  Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1.0, 
		  Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween.start()
