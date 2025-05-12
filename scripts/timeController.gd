extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var time=25
var red=0
var shake=0
var mostrar='loading'
var ultimoDamage=0
var damageTotal=0

func _ready():
	pass # Replace with function body.


func _on_Timer_timeout():
	if(time<=0):
		endLevel(false)
		return

	time=time-1

	if(red>0):
		mostrar=str(time)+"[color=red] -"+str(ultimoDamage)+"[/color]"
		red -=1
	else:
		mostrar=str(time)
		
	$seconds.bbcode_text="\n"+mostrar	
	
	if(shake>0):
		shake-=1
		$time.bbcode_text="\n[shake rate=7 level=15]Time: [/shake]"
	else:
		$time.bbcode_text="\nTime: "

func paused():
		$seconds.bbcode_text="\n[color=grey]"+str(time)+"[/color]"	
		red=0
		shake=0
		$segundero.stop()
		
func continued():
	$segundero.start()

func _on_controller_damage(damage):
	damageTotal+=damage
	if(red>0):
		ultimoDamage+=damage
	else:
		ultimoDamage=damage
	time=time-damage
	red=3
	shake=2


func endLevel(success,starsInfo=null):
	var stars=0
	var tiempoGastado=0
	if starsInfo:
		tiempoGastado=starsInfo[0]-time
		for i in starsInfo:
			if(i>tiempoGastado):
				stars+=1
	
	
	
	$segundero.stop()
	if(success):
		$"../Popup".showPopUp(time,tiempoGastado,damageTotal,true,stars)
	else:
		$"../Popup".showPopUp(time,tiempoGastado,damageTotal,false,stars)
