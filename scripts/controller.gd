extends Node


signal no_monsters
signal damage

var dragging = false
var click_radius = 32 # Size of the sprite.

var rayOrigin = Vector3()
var rayEnd = Vector3()
 
var colorDamage=load(str("res://instancias/gradientesect/colorRampDamage.tres"))
var colorNoDamage=load(str("res://instancias/gradientesect/colorRampNoDamage.tres"))
var colorExito=load(str("res://instancias/gradientesect/colorRampExito.tres"))
onready var camera=get_node("../Camera")

var cooldown=false #if couldown true you cannot draw
func _input(event):
	if cooldown or self.get_parent().cambiandoRonda:
		if(len(line.points)>0):
			destruirLinea(1,null)
		return
	if event is InputEventScreenDrag:

		var from = camera.project_ray_origin(event.position)
		var to = from + camera.project_ray_normal(event.position) * 100
		var cursorPos = Plane(Vector3.UP, Vector3.AXIS_Y).intersects_ray(from, to)
		$mouse.global_transform.origin=cursorPos
		generarPoligono(event.position)
		if(!$soundMouse.playing):
			$soundMouse.play()
	
	if event is InputEventScreenTouch:
		$soundMouse.stop()
		line.points=[]
		$mouse.global_transform.origin=Vector3(0,10,0)

onready var line: Line2D =  $Line2D

onready var polygon : Polygon2D= $Polygon2D



onready var height = get_viewport().get_visible_rect().size[1]
onready var distanciaMinima=height/40 # TODO EN FUNCION DEL TAMAÑO DE PANTALLA
onready var oneMeter=2.7*distanciaMinima
var monsters=null
func generarPoligono(cursorPos):
	$"../WindGrass/Grass".material_override.set_shader_param(
		"player_pos", $mouse.global_transform.origin
	)
	if(monsters==null):
		return
	if(line.get_point_count()>60):
		line.remove_point(0)

	
	if(line.get_point_count()>0 and line.points[line.get_point_count()-1].distance_to(cursorPos)<distanciaMinima):
		pass
	else:
		line.add_point(cursorPos)
	var nuevoSegmento= [line.points[line.get_point_count()-2],line.points[line.get_point_count()-1]]
	if(line.get_point_count()>2):
		for i in range(line.get_point_count()-1):
			if(i<line.get_point_count()-3):
				if(	Geometry.segment_intersects_segment_2d(nuevoSegmento[0],nuevoSegmento[1],line.points[i],line.points[i+1])):
					var array = PoolVector2Array()
					polygon.polygon=[]
					for i2 in range(line.get_point_count()):
						if(i2>i):
							array.append(line.points[i2])
					polygon.polygon=array
					var logroDamage=false
					for m in range(len(monsters)):
						var posMonst = camera.unproject_position(monsters[m].global_transform.origin)
						if( Geometry.is_point_in_polygon(posMonst,polygon.polygon )):
							monsters[m].damage(1)
							logroDamage=true
					polygon.polygon=[]
					if(logroDamage):
						destruirLinea(1,null)
						$success.play()
					else:
						destruirLinea(2,null)

var timer =0
func _ready():
	monsters = get_tree().get_nodes_in_group("monster")

var ataques=[]
func _process(delta):
	if(timer>1):
		monsters = get_tree().get_nodes_in_group("monster")
		if(len(monsters)==0):
			emit_signal("no_monsters")
		timer=0
		cooldown=false
	for segment in range(line.get_point_count()):
		for m in range(len(monsters)):
			if(segment!=0):
				if(-1 != Geometry.segment_intersects_circle(line.points[segment-1],line.points[segment],camera.unproject_position(monsters[m].global_transform.origin),oneMeter*monsters[m].radio)):
					$mouse.global_transform.origin=Vector3(0,10,0)
					destruirLinea(3,monsters[m].ataque)
					timer=0.4
					return
		ataques=get_tree().get_nodes_in_group("ataque")
		for a in range(len(ataques)):
			if(segment!=0):
				if(-1 != Geometry.segment_intersects_circle(line.points[segment-1],line.points[segment],camera.unproject_position(ataques[a].global_transform.origin),oneMeter*ataques[a].radio)):
					$mouse.global_transform.origin=Vector3(0,10,0)
					destruirLinea(3,ataques[a].ataque)
					timer=0.4
					return

	timer+=delta

#1 azul 2 amarillo 3 rojo
func destruirLinea(color,damage):
	$soundMouse.stop()
	$damage.emission_points=[]
	var triangulos= []
	for point in line.points:
		triangulos.append(camera.project_position(point,5))
	$damage.emission_points=triangulos
	$damage.restart()
	if color==1:
		$damage.color_ramp=colorExito
	elif color==2:
		$damage.color_ramp=colorNoDamage
	else:
		$brokenLine.play()
		camera.shake(0.4,40,1)
		$damage.color_ramp=colorDamage
		emit_signal("damage",damage)
		cooldown=true
	$damage.emitting=true
	$mouse.global_transform.origin=Vector3(0,10,0)
	line.points=[]
