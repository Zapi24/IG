extends Node

const Geometria = preload("res://Herramientas/geometria.gd")
const Constructor = preload("res://Herramientas/constructor.gd")
const Paleta = preload("res://Materiales/paleta.gd")

func _ready():
	_crear_blanco_ojos()
	_crear_pupila()
	
func _crear_blanco_ojos():
	var vertices = []
	var caras = []
	
	# Creamos un cilindro con altura pequeña
	Geometria.generar_cilindro(0.3, 0.1, 15, vertices, caras)
	
	var material = StandardMaterial3D.new()
	var malla = Constructor.modo_suave(vertices, caras, Paleta.BLANCO, material, true)
	
	var mesh_base = MeshInstance3D.new()
	mesh_base.mesh = malla
	
	# Transformaciones necesarias:
	# Lo rotamos 90º según el eje x
	mesh_base.rotation_degrees.x = 90
	# Lo aplastamos horizontalmente
	mesh_base.scale = Vector3(3.0, 1.0, 1.0)
	
	add_child(mesh_base)
	
func _crear_pupila():
	var vertices = []
	var caras = []
	
	# Creamos un cubo pequeño y muy fino
	Geometria.generar_cubo(0.6, 0.6, 0.05, vertices, caras)
	
	var material = StandardMaterial3D.new()
	var malla = Constructor.modo_suave(vertices, caras, Paleta.MORADO, material, true)
	
	var mesh_pupila = MeshInstance3D.new()
	mesh_pupila.mesh = malla
	
	# Transformaciones necesarias:
	# Lo movemos para ponerlo delante de lo blanco
	mesh_pupila.position.z = 0.1
	
	add_child(mesh_pupila)

	
