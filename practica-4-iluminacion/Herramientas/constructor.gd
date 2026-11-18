extends RefCounted

# Construye la malla con un sombrado suave para los bordes de las geometrias basicas del Enderman
static func modo_suave(vertices: Array, caras: Array, albedo: Color, material: StandardMaterial3D, sombreado: bool = false) -> ArrayMesh:
	var st = SurfaceTool.new()
	material.albedo_color = albedo
	
	if sombreado:
		material.shading_mode = BaseMaterial3D.SHADING_MODE_PER_VERTEX
	else:
		material.shading_mode = BaseMaterial3D.SHADING_MODE_PER_PIXEL
		
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	st.set_material(material)
	
	for cara in caras:
		for c in cara:
			st.add_vertex(vertices[c])
			
	st.generate_normals()
	
	return st.commit()
