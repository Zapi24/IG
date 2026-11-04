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
	
# Modo 4 para el sombreado suavee
static func modo_suave(vertices: Array, caras: Array, albedo: Color, material: StandardMaterial3D, sombreado: bool = false) -> ArrayMesh:
	var st =SurfaceTool.new()
	material.albedo_color = albedo
	
	if sombreado:
		# Sombreado más basico
		material.shading_mode = BaseMaterial3D.SHADING_MODE_PER_VERTEX
	else:
		# Sombreado más realista
		material.shading_mode = BaseMaterial3D.SHADING_MODE_PER_PIXEL
		
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	for cara in caras:
		for c in cara:
			st.add_vertex(vertices[c])
			
	st.generate_normals()
	
	return st.commit()
	
	
	
# Genera mallas por revolución a partir del perfil
static func generar_revolucion(perfil: Array, lados: int, tapa_inf: bool, tapa_sup: bool, vertices_out: Array, caras_out: Array):

	vertices_out.clear()
	caras_out.clear()
	
	var num_puntos = perfil.size()
	
	# Creamos los vertices nuevos rotando el perfil
	for i in lados:
		# TAU es una variable equivalente a 2*PI, es decir 360 grados en rads
		var angulo = i*(TAU/lados) 
		
		for p in perfil:
			# Rotamos cada punto sobre el eje Y
			var p_rotado = p.rotated(Vector3.UP, angulo)
			vertices_out.append(p_rotado)

	# Conectamos los vertices que acabamos de crear para generar las caras
	for i in lados:
		var sig_i = (i+1)%lados # EL %lados es necesario para que el ultimo se conecte con el primero xd

		for j in num_puntos - 1:
			var abajo_izq = i*num_puntos + j
			var arriba_izq = i*num_puntos + (j + 1)
			var abajo_der = sig_i*num_puntos + j
			var arriba_der = sig_i * num_puntos +(j + 1)

			# Dividimos el cuadrado en 2 triángulos 
			caras_out.append([abajo_izq, arriba_izq, arriba_der])
			caras_out.append([abajo_izq, arriba_der, abajo_der])
			
	# Creamos las tapas del jarrón
	if tapa_inf:
		var centro_inf = Vector3(0, perfil[0].y, 0)
		vertices_out.append(centro_inf)
		var idx_centro = vertices_out.size() - 1
		for i in lados:
			var actual = i * num_puntos
			var siguiente = ((i + 1) % lados) * num_puntos
			caras_out.append([idx_centro, siguiente, actual])

	if tapa_sup:
		var centro_sup = Vector3(0, perfil[num_puntos - 1].y, 0)
		vertices_out.append(centro_sup)
		var idx_centro = vertices_out.size() - 1
		for i in lados:
			var actual = i * num_puntos + (num_puntos - 1)
			var siguiente = ((i + 1) % lados) * num_puntos + (num_puntos - 1)
			caras_out.append([idx_centro, actual, siguiente])
			
			
