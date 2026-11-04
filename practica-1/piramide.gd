extends Node3D #Hereda de la raiz que es un nodo base en 3D
@export var altura: float = 0.5 # De esta manera la variable altura aparece en el inspector de godot


# Se ejecuta UNA VEZ al inicio (al darle al play) sirve para la inicialización.
func _ready():
	var piramide = crear_piramide(altura)
	
	var mesh_instance = MeshInstance3D.new()
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(1.0, 0.1, 0.2) #Color rojo
	
	# Añadimos la instancia el mesh y su material
	mesh_instance.mesh = piramide
	mesh_instance.material_override = material
	
	add_child(mesh_instance)
	
	
# Función que devuelve un ArrayMesh (una malla3D lista para usarse)
func crear_piramide(h: float) -> ArrayMesh:
	var st = SurfaceTool.new() #Herramienta para construir geometrías en 3D desde código
	
	st.begin(Mesh.PRIMITIVE_TRIANGLES) # Dibujamos usandoi triangulos
	
	# Definimos los vértices der la base (cuadrada)
	var p1 = Vector3(-0.5, 0, -0.5)
	var p2 = Vector3(0.5, 0, -0.5)
	var p3 = Vector3(0.5, 0, 0.5)
	var p4 = Vector3(-0.5, 0, 0.5)
	
	var apex = Vector3(0,h,0) #Definimos la punta de la piramide
	
	# Dibujamos todos los triangulos que forman la piramide
	_add_triangulo(st,p1,p2,apex)
	_add_triangulo(st,p2,p3,apex)
	_add_triangulo(st,p3,p4,apex)
	_add_triangulo(st,p4,p1,apex)
	
	_add_triangulo(st,p1,p3,p2)
	_add_triangulo(st,p1,p4,p3)
	
	return st.commit()
	
# FUnción auxuiliar que añade trianguloy  calcula su normal automáticamente
func _add_triangulo(st: SurfaceTool, a: Vector3, b: Vector3, c: Vector3):
	st.set_normal(Plane(a, b, c).normal)
	st.add_vertex(a)
	st.add_vertex(b)
	st.add_vertex(c)
	
