extends Node






var rosita ="pinkblob/PinkBlob"
var dragon = "dragon/Dragon"
var nivelId



var nivelInfo = {'id':0,'rondas':[
	[[rosita,0,0,5]],
	[[rosita,0,0,5],[rosita,3,3],[rosita,-3,-3]],
	[[dragon,0,0]]
	],'tuto':1}

# Called when the node enters the scene tree for the first time.
func _ready():
	$UI/points.time=nivelInfo['stars'][0]
	if 'tuto' in nivelInfo:
		cambiandoRonda=true
		self.add_child(load('res://Menus/tutorials/tuto'+str(nivelInfo['tuto'])+'.tscn').instance())
	else: 
		inicioRonda(0)


func tutoClosed():
	print("CLOSED")

	inicioRonda(0)


func inicioRonda(ronda):

	for enemigo in nivelInfo['rondas'][ronda]:
		var spawn=load("res://monsters/"+str(enemigo[0])+".tscn").instance()
		self.add_child(spawn)
		
		if(len(enemigo)>3):
			spawn.vida=enemigo[3]
		spawn.global_transform.origin=Vector3(enemigo[1],0,enemigo[2])
		spawn.spawn()
		$Timer.wait_time=1
		$Timer.start()
		yield($Timer, "timeout")
			
	print("acabo inicializacion")
	$UI/points.continued()
	cambiandoRonda=false

var rondaActual=0
var cambiandoRonda=false
func _on_controller_no_monsters():
	if(cambiandoRonda):
		return
	print("Ronda "+str(rondaActual)+" acabada")
	cambiandoRonda=true
	$controller/soundMouse.stop()
	$UI/points.paused()

	rondaActual+=1
	if(rondaActual<len(nivelInfo['rondas'])):
		$Timer.wait_time=3
		$Timer.start()
		yield($Timer, "timeout")
		inicioRonda(rondaActual)
	else:
		$Timer.wait_time=3
		$Timer.start()
		yield($Timer, "timeout")
		print("FIN nivel")
		$UI/Popup.levelId=nivelId
		$UI/points.endLevel(true,nivelInfo['stars'])


var mainmenu = load("res://Menus/mainMenu.tscn")

#al pulsar boton menu
func volverMenu():
	#save
	
	#puntos


	
	#return menu
	var menu = mainmenu.instance()
	var odin=get_tree().get_root().get_node("odin")
	odin.add_child(menu)
	odin.remove_child(odin.get_node("level"))





