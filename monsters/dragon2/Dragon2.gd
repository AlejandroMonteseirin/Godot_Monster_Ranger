extends KinematicBody


var radio=1
var rng = RandomNumberGenerator.new()
onready var camera = get_tree().get_nodes_in_group("camera")[0]
onready var oneMeter=get_viewport().get_visible_rect().size[1]/40*2.7
var muerto=false


export var vida = 15
export var ataque=5

export var animacion_andar="Flying_Idle"
export var animacion_correr="Fast_Flying"
export var animacion_ataque="Headbutt"
export var tiempoCambio=1 #tiempo tras el cual cambiamos de direccion
export var multiplicadorVelocidad=3


onready var bolaFuego= preload("res://instancias/ataques/bolaFuego.tscn")


func _ready():
	rng.randomize()
	$AnimationPlayer.get_animation(animacion_andar).loop=true
	$AnimationPlayer.get_animation(animacion_correr).loop=true
	$cooldown.wait_time=rand_range(1, 2)
	$cooldown.start()


var angulo=0
var atacando=false
var numeroBolasFuego
var ataqueElegido=1
func spawn():
	$spawn.emitting=true


var puedeAtacar=false
func _physics_process(delta):
	if muerto:
		return
	if(puedeAtacar):
		ataqueElegido=int(rand_range(1,3.99))
		$warning.emitting=true
		atacando=true
		puedeAtacar=false
		$atacando.wait_time=int(rand_range(2, 4))
		$atacando.start()
		$bolasFuego.start()
	if atacando:
		self.rotation[1]=lerp_angle(self.rotation[1],angulo,multiplicadorVelocidad*2*delta)
	else:
		andar(delta)
		self.rotation[1]=lerp_angle(self.rotation[1],angulo,multiplicadorVelocidad*2*delta)


var direccionActual
var contadorSegundos=5
var velocidad=1 #va entre 1 y 2
func andar(delta):
	contadorSegundos=contadorSegundos+1*delta
	if(contadorSegundos>tiempoCambio+1):
		contadorSegundos=rand_range(0, 2)
		velocidad=rand_range(1,2)
		direccionActual=Vector3(rand_range(-1, 1),0,rand_range(-1, 1)).normalized()*velocidad*multiplicadorVelocidad
		rotacionSuave(direccionActual)
		if(velocidad<1.5):
			$AnimationPlayer.playback_speed=rand_range(0.5, 1)
			$AnimationPlayer.play(animacion_andar)
		else:
			$AnimationPlayer.playback_speed=rand_range(1, 1.5)
			$AnimationPlayer.play(animacion_correr)
	if(self.move_and_collide(direccionActual*delta)!=null):
		direccionActual=Vector3(rand_range(-1, 1),0,rand_range(-1, 1)).normalized()*rand_range(0.5,1)*multiplicadorVelocidad
		rotacionSuave(direccionActual)

func rotacionSuave(direccion):
	angulo=-direccion.normalized().signed_angle_to(Vector3(0,0,1),Vector3(0,1,0))



func damage(damage):
	if muerto:
		return
	vida=vida-damage
	if(vida<=0):
		$cooldown.stop()
		$atacando.stop()
		$bolasFuego.stop()
		$AnimationPlayer.play("Death")
		$Capture.restart()
		$Capture.amount=$Capture.amount*2
		$Capture.lifetime=0.8
		$Capture.explosiveness=0
		$Capture.emitting=true
		muerto=true
		self.remove_from_group("monster")
		$CollisionShape.disabled=true
		voladorCae()
		return
	$Capture.restart()
	$Capture.emitting=true
	$vidas.showVida(vida,camera.unproject_position(self.global_transform.origin)+Vector2(0,-oneMeter),oneMeter)




func voladorCae():
	$voladorCae.interpolate_property(self,"translation",Vector3(self.global_transform.origin.x,0,self.global_transform.origin.z),Vector3(self.global_transform.origin.x,-2,self.global_transform.origin.z),1)
	$voladorCae.start()




func _on_cooldown_timeout():
	puedeAtacar=true 


func _on_atacando_timeout():
	print("acabo ataque")
	atacando=false
	$bolasFuego.stop()
	$cooldown.wait_time=rand_range(5, 9)
	$cooldown.start() 



func _on_bolasFuego_timeout():
	if(ataqueElegido==1):
		direccionActual=direccionActual.rotated(Vector3(0,1,0),deg2rad(15))
	elif(ataqueElegido==2):
		direccionActual=direccionActual.rotated(Vector3(0,1,0),deg2rad(-15))
	elif(ataqueElegido==3):
		direccionActual=direccionActual.rotated(Vector3(0,1,0),deg2rad(rand_range(-180,180)))
	
	rotacionSuave(direccionActual)
	$AnimationPlayer.stop(true)
	$AnimationPlayer.play(animacion_ataque)
	var fuego=bolaFuego.instance()
	self.get_parent().add_child(fuego)
	fuego.global_transform.origin=self.global_transform.origin+Vector3(0,1,0)
	fuego.vectorMovimiento=direccionActual.normalized()*rand_range(5, 7)


