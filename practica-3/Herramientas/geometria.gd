extends RefCounted

# Genera los vertices y las caras de un cubo sesún su ancho, alto y profundidad
static func generar_cubo(ancho: float, alto: float, profundidad: float, vertices_out: Array, caras_out: Array):
	
	# Por si pasamos vectores con información para la salida los limpiamos priemro
	vertices_out.clear()
	caras_out.clear()
	
	var x = ancho / 2.0
	var y = alto / 2.0
	var z = profundidad / 2.0
	
	# Creamos los 8 vertices del cubo centrado en el origen
	var v = [
		Vector3(-x, -y, -z), 
		Vector3(x, -y, -z),  
		Vector3(x, -y, z),   
		Vector3(-x, -y, z),  
		Vector3(-x, y, -z),  
		Vector3(x, y, -z),   
		Vector3(x, y, z),   
		Vector3(-x, y, z)  
	]
	
	# Metemos los vertices en el array
	vertices_out.append_array(v)
	
	# Generamos los triangulos del cubo y  lo metemos en el array de caras (2 triangulos por cara)
	caras_out.append_array([
		[4, 5, 6], [4, 6, 7], # Arriba
		[0, 3, 2], [0, 2, 1], # Abajo
		[3, 7, 6], [3, 6, 2], # Frente
		[0, 1, 5], [0, 5, 4], # Atrás
		[1, 2, 6], [1, 6, 5], # Derecha
		[0, 4, 7], [0, 7, 3]  # Izquierda
	])
	

# Función para generar revolución a partir del perfil
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
	

# Genera un cilindro dado el perfil usando la función de revolución
static func generar_cilindro(radio: float, altura: float, lados: int, vertices_out: Array, caras_out: Array):
	
	# El perfil de un cilindro es una recta vertical separada por el radio
	var perfil = [
			Vector3(0, -altura / 2.0, 0), # Punto inferior central
			Vector3(radio, -altura / 2.0, 0), # Punto inferior
			Vector3(radio, altura / 2.0, 0),   # Punto superior
			Vector3(0, altura / 2.0, 0) # Punto superior central
		]
	
	# Llamamos a la revolución cerrando ambas tapas
	generar_revolucion(perfil, lados, true, true, vertices_out, caras_out)
