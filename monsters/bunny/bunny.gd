extends KinematicBody


var radio=1
var rng = RandomNumberGenerator.new()
onready var camera = get_tree().get_nodes_in_group("camera")[0]
onready var oneMeter=get_viewport().get_visible_rect().size[1]/40*2.7
var muerto=false


export var vida = 9
export var ataque=3

export var animacion_andar="Walk"
export var animacion_correr="Run"
export var animacion_troleo="Wave"
export var animacion_cansado="Yes"
func _ready():
	rng.randomize()
	$AnimationPlayer.get_animation(animacion_correr).loop=true
	$AnimationPlayer.get_animation(animacion_andar).loop=true
	$AnimationPlayer.get_animation(animacion_troleo).loop=true
	$AnimationPlayer.get_animation(animacion_cansado).loop=true


var angulo=0
var multiplicadorVelocidad=3


func spawn():
	$spawn.emitting=true
	$AnimationPlayer.play(animacion_troleo)
func _physics_process(delta):
	if muerto:
		return
	else:
		andar(delta)
		self.rotation[1]=lerp_angle(self.rotation[1],angulo,multiplicadorVelocidad*delta)


var direccionActual=Vector3(0,0,0)



var estamina=-8
func andar(delta):	
	if(self.move_and_collide(multiplicadorVelocidad*direccionActual*delta)!=null):
		direccionActual=direccionActual.rotated(Vector3(0,1,0),deg2rad(rand_range(90,270)))
		rotacionSuave(direccionActual)

func rotacionSuave(direccion):
	angulo=-direccion.normalized().signed_angle_to(Vector3(0,0,1),Vector3(0,1,0))


func damage(damage):
	if muerto:
		return
	vida=vida-damage
	if(vida<=0):
		$Timer.stop()
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
	$Capture.restart()
	$Capture.emitting=true
	$vidas.showVida(vida,camera.unproject_position(self.global_transform.origin)+Vector2(0,-oneMeter),oneMeter)


func _on_Timer_timeout():
	if(estamina==15):
		direccionActual=Vector3(rand_range(-1, 1),0,rand_range(-1, 1)).normalized()
		$AnimationPlayer.play(animacion_correr)
		multiplicadorVelocidad=rand_range(10, 12)
		rotacionSuave(direccionActual)
	if estamina==9:
		direccionActual=Vector3(rand_range(-1, 1),0,rand_range(-1, 1)).normalized()

		$AnimationPlayer.play(animacion_correr)
		multiplicadorVelocidad=rand_range(5, 8)
		rotacionSuave(direccionActual)
	if estamina==5:
		direccionActual=Vector3(rand_range(-1, 1),0,rand_range(-1, 1)).normalized()
		$AnimationPlayer.play(animacion_andar)
		multiplicadorVelocidad=rand_range(2, 3)
		rotacionSuave(direccionActual)
	if estamina==0:
		direccionActual=Vector3(1,0,0).normalized()
		$AnimationPlayer.play(animacion_cansado)
		multiplicadorVelocidad=0
		rotacionSuave(direccionActual)
	if estamina<-2 && rand_range(0, 1)>0.7:
		$warning.emitting=true
		estamina=int(rand_range(16, 22))
		direccionActual=Vector3(rand_range(-1, 1),0,rand_range(-1, 1)).normalized()
		$AnimationPlayer.play(animacion_correr)
		multiplicadorVelocidad=rand_range(12, 14)
		rotacionSuave(direccionActual)
	estamina=estamina-1
