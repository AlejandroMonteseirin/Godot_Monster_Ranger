extends KinematicBody


var radio=1
var rng = RandomNumberGenerator.new()
onready var camera = get_tree().get_nodes_in_group("camera")[0]
onready var oneMeter=get_viewport().get_visible_rect().size[1]/40*2.7
var muerto=false

export var cargaTiempoMin=5
export var cargaTiempoMax=15
export var vida = 9
export var ataque=3
# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	$AnimationPlayer.get_animation("Jump").loop=true
	$AnimationPlayer.get_animation("Walk").loop=true
	$AnimationPlayer.get_animation("Dance").loop=true
	$AnimationPlayer.get_animation("Bite_Front").loop=true
	$cooldown.wait_time=rand_range(5, 15)
	$cooldown.start()


var angulo=0
var atacando=false


func spawn():
	$spawn.emitting=true

func _physics_process(delta):
	if muerto:
		return
	if(puedeAtacar):
		$warning.emitting=true
		puedeAtacar=false
		$tiempoCarga.wait_time=rand_range(1, 2.5)
		$tiempoCarga.start()
		$cooldown.start()
		atacando=true
		direccionCarga=Vector3(rand_range(-1, 1),0,rand_range(-1, 1)).normalized()
		rotacionSuave(direccionCarga)
		$AnimationPlayer.play("Bite_Front")
	if atacando:
		cargar(delta)
		self.rotation[1]=lerp_angle(self.rotation[1],angulo,2*delta)
	else:
		andar(delta)
		self.rotation[1]=lerp_angle(self.rotation[1],angulo,1*delta)


var direccionActual
var contadorSegundos=5

var direccionCarga
func cargar(delta):
	if(self.move_and_collide(direccionCarga*7*delta)!=null):
		direccionCarga=Vector3()
		$AnimationPlayer.play("Dance")


func andar(delta):
	contadorSegundos=contadorSegundos+1*delta
	if(contadorSegundos>5):
		contadorSegundos=rand_range(0, 2)
		direccionActual=Vector3(rand_range(-2, 2),0,rand_range(-2, 2))
		rotacionSuave(direccionActual)
		if(direccionActual.length_squared()<1):
			$AnimationPlayer.play("Dance")
		elif(direccionActual.length_squared()<3):
			$AnimationPlayer.playback_speed=rand_range(0.8, 1)
			$AnimationPlayer.play("Walk")
		else:
			$AnimationPlayer.playback_speed=rand_range(1, 1.2)
			$AnimationPlayer.play("Jump")
	if(self.move_and_collide(direccionActual*delta)!=null):
		direccionActual=Vector3(rand_range(-2, 2),0,rand_range(-2, 2))
		rotacionSuave(direccionActual)

func rotacionSuave(direccion):
	angulo=-direccion.normalized().signed_angle_to(Vector3(0,0,1),Vector3(0,1,0))

var caible = true
var caido=false
func damage(damage):
	if muerto:
		return
	vida=vida-damage
	if(vida<=0):
		$AnimationPlayer.play("Death")
		$Capture.restart()
		$Capture.amount=$Capture.amount*2
		$Capture.lifetime=0.8
		$Capture.explosiveness=0
		$Capture.emitting=true
		muerto=true
		self.remove_from_group("monster")
		$CollisionShape.disabled=true
		return
	if(caible and not caido and not atacando):
		caido=true
		caible=false
		$AnimationPlayer.play("Death")
		direccionActual=Vector3.ZERO
		contadorSegundos=4
		$caible.start() 
	$Capture.restart()
	$Capture.emitting=true
	$vidas.showVida(vida,camera.unproject_position(self.global_transform.origin)+Vector2(0,-oneMeter),oneMeter)





var primeraVez=true
func _on_AnimationPlayer_animation_finished(anim_name):
	
	if anim_name=="Death" and primeraVez and vida>0:
		primeraVez=false
		$AnimationPlayer.play_backwards("Death")
	elif anim_name=="Death" and not primeraVez:
		primeraVez=true
		caido=false
	



var puedeAtacar=false
func _on_cooldown_timeout():
	$cooldown.wait_time=rand_range(cargaTiempoMin, cargaTiempoMax)
	puedeAtacar=true # Replace with function body.


func _on_tiempoCarga_timeout():
	atacando=false
	contadorSegundos=999


func _on_caible_timeout():
	caible=true

