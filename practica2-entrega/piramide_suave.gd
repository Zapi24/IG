extends Node3D

@export var altura := 1.5
@export var lado := 1.0
@export var material : StandardMaterial3D

func _ready():
	var mesh := ArrayMesh.new()
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	var h = altura / 2.0
	var l = lado / 2.0
	
	var v = [
		Vector3(-l, 0, -l), # v0 base
		Vector3(l, 0, -l),  # v1 base
		Vector3(l, 0, l),   # v2 base
		Vector3(-l, 0, l),  # v3 base
		Vector3(0, h, 0)    # v4 punta
	]
	
	var caras = [
		[0, 1, 4], # cara1
		[1, 2, 4], # cara2
		[2, 3, 4], # cara3
		[3, 0, 4], # cara4
		[0, 3, 2], # base1
		[0, 2, 1]  # base2
	]
	
	# Para construir la malla (le metemos solo los vertices)
	for cara in caras:
		for idx in cara:
			st.add_vertex(v[idx])
			
	# Calcula las normales automáticamente para el sombreado suaveeee
	st.generate_normals()
			
	st.commit(mesh) 
	
	# Creamos el mesh y le metemos el material
	var m = MeshInstance3D.new()
	m.mesh = mesh

	if material:
		m.material_override = material
	add_child(m)
	
	
