extends Node3D #Hereda de la raiz que es un nodo base en 3D
@export var altura: float = 0.5 # De esta manera la variable altura aparece en el inspector de godot

var mesh_instance = MeshInstance3D.new()
var material = StandardMaterial3D.new()

# Cargamos el archivo de los modos
var modo = load("res://modos_malla.gd")

# Variables globales
var vertices: Array
var caras: Array
var colores: Array
var albedo = Color(1.0, 0.4, 0.102, 1.0) # Color naranja fijo

# Se ejecuta UNA VEZ al inicio (al darle al play) sirve para la inicialización.
func _ready():
	
	# Definimos los puntos
	vertices = [
		Vector3(-0.5, 0.5, -0.5),    
		Vector3(0.5, 0.5, -0.5),    
		Vector3(0.5, 0.5, 0.5),      
		Vector3(-0.5, 0.5, 0.5),    
		Vector3(0, altura + 0.5, 0), # Punta de arriba
		Vector3(0, -altura + 0.5, 0) # Punta de abajo
	]
	
	# Definimos las caras
	caras = [
		[0, 1, 4], [1, 2, 4], [2, 3, 4], [3, 0, 4], # Las 4 caras superiores
		[1, 0, 5], [2, 1, 5], [3, 2, 5], [0, 3, 5]  # Las 4 caras inferiores
	]
	
	# Definimos los colores (uno para cada cara)
	colores = [
		Color(1, 0, 0), Color(0, 1, 0), Color(0, 0, 1), Color(0.5, 0.5, 1),
		Color(1, 0, 1), Color(0, 1, 1), Color(2, 1, 0), Color(1, 0.5, 0)
	]
	
	# Inicializamos con el primer modo
	mesh_instance.mesh = modo.modo1(vertices, caras, colores, material)
	mesh_instance.material_override = material
	add_child(mesh_instance)
	
func _input(event):
	# Creamos un material vacio cada vez que tocamos una tecla para que los modos no se fusionen
	var nuevo_material = StandardMaterial3D.new()
	
	# Vemos si se ha pulsado una tecla
	if event is InputEventKey and event.pressed:
		
		match event.keycode:
			KEY_1: 
				mesh_instance.mesh = modo.modo1(vertices, caras, colores, nuevo_material)
				mesh_instance.material_override = nuevo_material
			KEY_2:
				mesh_instance.mesh = modo.modo2(vertices, caras, albedo, nuevo_material)
				mesh_instance.material_override = nuevo_material
			KEY_3: 
				mesh_instance.mesh = modo.modo3(vertices, caras, albedo, nuevo_material)
				mesh_instance.material_override = nuevo_material
		



	
