extends Node3D

var mesh_instance = MeshInstance3D.new()
var material = StandardMaterial3D.new()
var modo = load("res://modos_malla.gd")

var vertices: Array = []
var caras: Array = []
var colores: Array = []
var albedo = Color(0.976, 0.283, 0.593, 1.0) 

func _ready():

	var perfil = [
		Vector3(0.3, 0.0, 0), 
		Vector3(0.5, 0.2, 0), 
		Vector3(0.6, 0.5, 0), 
		Vector3(0.2, 0.8, 0),
		Vector3(0.2, 1.0, 0), 
		Vector3(0.3, 1.1, 0)  
	]
	
	# Le pasamos el perfil, buscamos unos 15 lados, con tapasup en true tapainf en False para que este hueco
	# Obtenemos los vertices y caras generados
	modo.generar_revolucion(perfil, 15, true, false, vertices, caras)
	
	# Generamos los colores automáticamente para cada cara
	for i in caras.size():
		colores.append(Color(randf(), randf(), randf())) # randf() da un valor random entre 0 y 1
		
	# Creamos la malla
	mesh_instance.mesh = modo.modo_suave(vertices, caras, albedo, material, false)
	mesh_instance.material_override = material
	add_child(mesh_instance)

# Le metemos los mismos controles que teniamos pero para el prisma
func _input(event):
	var nuevo_material = StandardMaterial3D.new()
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
			KEY_4:
				mesh_instance.mesh = modo.modo_suave(vertices, caras, albedo, nuevo_material, false)
				mesh_instance.material_override = nuevo_material
