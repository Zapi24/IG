extends Node3D

var mesh_instance = MeshInstance3D.new()
var material = StandardMaterial3D.new()
var modo = load("res://modos_malla.gd")

var vertices: Array = []
var caras: Array = []
var colores: Array = []
var albedo = Color(0.797, 0.029, 0.543, 1.0) 

func _ready():
	var perfil = [
		Vector3(0.5, 0.0, 0), # Para la base
		Vector3(0.0, 1.5, 0)  # Para la punta
	]
	
	# Llamamos a la revolución	
	modo.generar_revolucion(perfil, 15, true, false, vertices, caras)
	
	# Lo mismo colores random
	for i in caras.size():
		colores.append(Color(randf(), randf(), randf()))
		
	# Inicialmente esta muy suave
	mesh_instance.mesh = modo.modo_suave(vertices, caras, albedo, material, false)
	mesh_instance.material_override = material
	add_child(mesh_instance)

# LoS de siempre
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
