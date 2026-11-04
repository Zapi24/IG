extends Node3D

 # Tiene que ser static para poder llamarla desde otros scipts sin crear insancia
# El primer modo son un color por cara de la figura
static func modo1(vertices: Array, caras: Array, colores: Array, material: StandardMaterial3D) -> ArrayMesh:
	var st = SurfaceTool.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED # Apagamos las luces y las sombras 
	material.vertex_color_use_as_albedo = true # Para que ignore el color base y use los colores que le pasamos
	
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	for i in caras.size(): # Recorremos las 8 caras del rombo
		st.set_color(colores[i])
		
		# Le ponemos los vertices
		st.add_vertex(vertices[caras[i][0]])
		st.add_vertex(vertices[caras[i][1]])
		st.add_vertex(vertices[caras[i][2]])
		
	return st.commit()
	
# en el segundo modo utilizados iluminación plana
static func modo2(vertices: Array, caras: Array, albedo: Color, material: StandardMaterial3D) -> ArrayMesh:
	var st = SurfaceTool.new()
	material.disable_ambient_light = true # Apagamos la luz ambiental, las caras sin luz no se verán
	material.albedo_color = albedo # Le metemos el color que pasamos por parámetro
	
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	for i in caras.size(): 
		var p1 = vertices[caras[i][0]]
		var p2 = vertices[caras[i][1]]
		var p3 = vertices[caras[i][2]]
		
		# Calculamos la normal
		st.set_normal(Plane(p1,p2,p3).normal)
		
		# Le ponemos los vertices
		st.add_vertex(vertices[caras[i][0]])
		st.add_vertex(vertices[caras[i][1]])
		st.add_vertex(vertices[caras[i][2]])
		
	return st.commit()
	
# En el modo 3 solo vemos las aristas dibujadas
static func modo3(vertices: Array, caras: Array, albedo: Color, material: StandardMaterial3D) -> ArrayMesh:
	var st = SurfaceTool.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED # Apagamos las luces y las sombras 
	material.albedo_color = albedo
	
	st.begin(Mesh.PRIMITIVE_LINES) # ahora es primitive_lines
	for i in caras.size(): 
		var p1 = vertices[caras[i][0]]
		var p2 = vertices[caras[i][1]]
		var p3 = vertices[caras[i][2]]
		
		# Linea 1 de p1 a p2
		st.add_vertex(p1)
		st.add_vertex(p2)
		# Linea 2 de p2 a p3
		st.add_vertex(p2)
		st.add_vertex(p3)	
		# Linea 3 de p3 a p1
		st.add_vertex(p3)
		st.add_vertex(p1)
		
	return st.commit()
		
		
