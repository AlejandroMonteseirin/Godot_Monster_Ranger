extends Popup


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var menu = load("res://Maps/mainMenu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
var levelId=0
var starsConseguidas
func showPopUp(time,tiempoGastado,damage,success,stars):
	self.popup()
	if(success):
		starsConseguidas=stars
		var color='red'
		if stars==2:
			$VBoxContainer/PanelContainer/Container2/star2.modulate=Color(1,1,1,0)
			color='yellow'
		if stars==3:
			$VBoxContainer/PanelContainer/Container2/star2.modulate=Color(1,1,1,0)
			$VBoxContainer/PanelContainer/Container3/star3.modulate=Color(1,1,1,0)
			color='green'
		
		
		$VBoxContainer/success.show()
		var tween :=create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
		tween.tween_property(self,"modulate",Color(1,1,1,1),1)
		$Timer.wait_time=1
		$Timer.start()
		yield($Timer, "timeout")
		$VBoxContainer/Stadistics.show()
		tween =create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
		tween.tween_property($VBoxContainer/Stadistics,"modulate",Color(1,1,1,1),1)
		$VBoxContainer/data.show()
		$Timer.start()
		yield($Timer, "timeout")
		$VBoxContainer/data.append_bbcode("   - Time: [color=silver][fade start=0 length=14]   "+str(tiempoGastado)+"s[/fade][/color]")
		$Timer.start()
		yield($Timer, "timeout")
		$VBoxContainer/data.append_bbcode("\n      - Remaining Time: [color=gold][fade start=0 length=14]   "+str(time)+"s[/fade][/color]")
		$Timer.start()
		yield($Timer, "timeout")
		$VBoxContainer/data.append_bbcode("\n	   - Damage: [color=red][shake rate=7 level=15]   -"+str(damage)+"[/shake][/color] ")
		$Timer.start()
		yield($Timer, "timeout")
		$VBoxContainer/data.append_bbcode("\n\n      - Total: [color="+str(color)+"][tornado radius=5 freq=2]   "+str(tiempoGastado)+"[/tornado][/color]")
		$Timer.wait_time=0.5
		$Timer.start()
		yield($Timer, "timeout")
		tween =create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
		tween.tween_property($VBoxContainer/PanelContainer/Container/star1,"modulate:a",1.0,1)
		tween.tween_property($VBoxContainer/PanelContainer/Container2/star2,"modulate:a",1.0,1)
		tween.tween_property($VBoxContainer/PanelContainer/Container3/star3,"modulate:a",1.0,1)
		$VBoxContainer/data.show()
		$Timer.start()
		yield($Timer, "timeout")
		$Timer.start()
		yield($Timer, "timeout")
		$Timer.start()
		yield($Timer, "timeout")
		$Timer.start()
		yield($Timer, "timeout")
		tween =create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
		tween.tween_property($VBoxContainer/botones,"modulate",Color(1,1,1,1),1)
		$VBoxContainer/botones.show()
	else:
		starsConseguidas=0
		$VBoxContainer/fail.show()
		var tween :=create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
		tween.tween_property($VBoxContainer/botones,"modulate",Color(1,1,1,1),1)
		$Timer.wait_time=1
		$Timer.start()
		yield($Timer, "timeout")
		$VBoxContainer/botones.show()
		




func _on_menu_pressed():
	print("MENU")
	save()
	var odin=get_tree().get_root().get_node("odin")
	odin.add_child(menu.instance())
	odin.remove_child(odin.get_node("level"))
	
func save():
	var odin=get_tree().get_root().get_node("odin")
	odin.save(levelId,starsConseguidas)


func _on_exit_pressed():
	var odin=get_tree().get_root().get_node("odin")
	odin.add_child(menu.instance())
	odin.remove_child(odin.get_node("level"))
