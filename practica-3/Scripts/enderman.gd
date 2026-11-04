extends Node

# Cargamos los objetos que usaremos en este script
const Geometria = preload("res://Herramientas/geometria.gd")
const Constructor = preload("res://Herramientas/constructor.gd")
const Paleta = preload("res://Materiales/paleta.gd")
const EscenaOjo = preload("res://Escenas/ojo.tscn") # Cargamos la escena con el ojo ya creado

# Referenciamos a los nodos
@onready var nodo_cuerpo = $Cuerpo
@onready var nodo_cabeza = $Cuerpo/Cabeza
@onready var nodo_pierna_izq = $PiernaIzq
@onready var nodo_pierna_der = $PiernaDer
@onready var nodo_brazo_izq = $Cuerpo/BrazoIzq 
@onready var nodo_brazo_der = $Cuerpo/BrazoDer 
@onready var bloque = $"../GrassBlock"

# Para la velocidad de giro
const Velocidad_giro = 1.5

# Variables para la animación
var animando = false
var bloque_cogido = false


func _ready():
	#_construir_cubo_o_cilindro(false)
	_construir_cuerpo()
	_construir_cabeza()
	_construir_piernas()
	_construir_brazos()
	

func _construir_cuerpo():
	nodo_cuerpo.position.y = 3.0 # Ponemos el cuerpo encima de las patas
	
	var vertices = []
	var caras = []
	
	# Generamos el cuerpo a partir de un cubo
	Geometria.generar_cubo(0.8, 1.5, 0.4, vertices, caras)
	
	var material = StandardMaterial3D.new()
	var malla = Constructor.modo_suave(vertices, caras, Paleta.NEGRO, material, true)
	
	var mesh_cuerpo = MeshInstance3D.new()
	mesh_cuerpo.mesh = malla
	
	# Subimos el cuerpo al 0.75 (la mitad de su altura) para ajustar el eje de rotación sobre el 0,0,0
	mesh_cuerpo.position.y = 0.75
	
	nodo_cuerpo.add_child(mesh_cuerpo)

func _construir_cabeza():
	nodo_cabeza.position.y = 1.5 #Ponemos la cabeza encima del cuerpo
	
	var vertices = []
	var caras = []
	Geometria.generar_cubo(1.0, 1.0, 1.0, vertices, caras) # Será ña cabeza
	
	var material = StandardMaterial3D.new()
	var malla = Constructor.modo_suave(vertices, caras, Paleta.NEGRO, material, true)
	
	var mesh_cabeza = MeshInstance3D.new()
	mesh_cabeza.mesh = malla
	
	# Ponemos la cabeza sobre 0,0,0mpara ajustar su eje de rotación
	mesh_cabeza.position.y = 0.5
	nodo_cabeza.add_child(mesh_cabeza) 
	
	# Creamos los dos ojos
	var ojo_izq = EscenaOjo.instantiate()
	var ojo_der = EscenaOjo.instantiate()
	
	# Los posicionamos
	ojo_izq.scale = Vector3(0.2, 0.2, 0.2)
	ojo_izq.position = Vector3(-0.25, 0.5, 0.5)
	ojo_der.scale = Vector3(0.2, 0.2, 0.2)
	ojo_der.position = Vector3(0.25, 0.5, 0.5)
	
	# Añadimos los ojos a la cabeza
	nodo_cabeza.add_child(ojo_izq)
	nodo_cabeza.add_child(ojo_der)
	
func _construir_piernas():
	# Posicionamos las piernass
	nodo_pierna_izq.position = Vector3(-0.2, 1.5, 0)
	nodo_pierna_der.position = Vector3(0.2, 1.5, 0)
	
	var pata_izq = _fabricar_extremidad(0.15, 3.0)
	var pata_der = _fabricar_extremidad(0.15, 3.0)
	
	nodo_pierna_izq.add_child(pata_izq)
	nodo_pierna_der.add_child(pata_der)
	
func _construir_brazos():
	# Posicionamos los brazos
	nodo_brazo_izq.position = Vector3(-0.55, 1.5, 0)
	nodo_brazo_der.position = Vector3(0.55, 1.5, 0)
	
	var brazo_izq = _fabricar_extremidad(0.15, 4.0)
	var brazo_der = _fabricar_extremidad(0.15, 4.0)
	
	# Los ponemos bajo el 0,0,0 para que tengan el eje de rotación en los hombros
	brazo_izq.position.y = -2.0
	brazo_der.position.y = -2.0
	
	nodo_brazo_izq.add_child(brazo_izq)
	nodo_brazo_der.add_child(brazo_der)
	

# Función auxiliar que genera cilindro negro devolviendo el nodo listo para usar
func _fabricar_extremidad(radio: float, altura: float) -> MeshInstance3D:
	var vertices = []
	var caras = []
	
	Geometria.generar_cilindro(radio, altura, 15, vertices, caras)
	
	var material = StandardMaterial3D.new()
	var malla = Constructor.modo_suave(vertices, caras, Paleta.NEGRO, material, true)
	
	var mesh_instancia = MeshInstance3D.new()
	mesh_instancia.mesh = malla
	
	return mesh_instancia

# Si figura es true mostramos el cubo default y si es false el cilindro
func _construir_cubo_o_cilindro(figura: bool):
	var vertices = []
	var caras = []
	
	if figura:
		Geometria.generar_cubo(1.0, 1.0, 1.0, vertices, caras)
	else:
		Geometria.generar_cilindro(1.0, 1.0, 15, vertices, caras)
	
	var material = StandardMaterial3D.new()
	var malla = Constructor.modo_suave(vertices, caras, Paleta.NEGRO, material, true) # Cargamos el negro de paleta.gd
	
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = malla
	add_child(mesh_instance)
	
	
func _process(delta):
	
	if not animando: 
		# Si pulsamos enter activamos la animación
		if Input.is_action_just_pressed("animacion"):
			# Establecemos todo a sus valores de origen
			nodo_cuerpo.rotation.x = deg_to_rad(0)
			nodo_brazo_der.rotation.x = deg_to_rad(0)
			nodo_brazo_izq.rotation.x = deg_to_rad(0)
			nodo_cabeza.rotation.x = deg_to_rad(0)
			animando = true
	
		# Devolverá -1 si se pulsa la primera opción, 1 si se pulsa la segunda y 0 si no se pulsa nada
		var mov_cuerpo = Input.get_axis("cuerpo_atras", "cuerpo_alante")
		var mov_brazos = Input.get_axis("brazos_abajo", "brazos_arriba")
		var mov_cuello = Input.get_axis("cuello_abajo", "cuello_arriba")
		
		# Aplicamos rotación en el eje x
		if mov_cuerpo != 0:
				nodo_cuerpo.rotation.x += mov_cuerpo * Velocidad_giro * delta
				
				# Establecemos los límites
				if nodo_cuerpo.rotation.x > deg_to_rad(45):
					nodo_cuerpo.rotation.x = deg_to_rad(45)
				if nodo_cuerpo.rotation.x < deg_to_rad(-45):
					nodo_cuerpo.rotation.x = deg_to_rad(-45)
			
		if mov_brazos != 0:
			nodo_brazo_izq.rotation.x += mov_brazos * Velocidad_giro * delta
			nodo_brazo_der.rotation.x += mov_brazos * Velocidad_giro * delta
			
			# Establecemos los límites para los dos brazos
			if nodo_brazo_izq.rotation.x > deg_to_rad(80):
				nodo_brazo_izq.rotation.x = deg_to_rad(80)
			if nodo_brazo_izq.rotation.x < deg_to_rad(-80):
				nodo_brazo_izq.rotation.x = deg_to_rad(-80)
			
			if nodo_brazo_der.rotation.x > deg_to_rad(80):
				nodo_brazo_der.rotation.x = deg_to_rad(80)
			if nodo_brazo_der.rotation.x < deg_to_rad(-80):
				nodo_brazo_der.rotation.x = deg_to_rad(-80)
			
		if mov_cuello != 0:
			nodo_cabeza.rotation.x += mov_cuello * Velocidad_giro * delta
			
			# Establecemos los límites
			if nodo_cabeza.rotation.x > deg_to_rad(35):
				nodo_cabeza.rotation.x = deg_to_rad(35)
			if nodo_cabeza.rotation.x < deg_to_rad(-35):
				nodo_cabeza.rotation.x = deg_to_rad(-35)
			
		# Vamos imprimiendo los valores para depurar
		if mov_cuerpo != 0 or mov_brazos != 0 or mov_cuello != 0:
			var deg_cuerpo = snapped(rad_to_deg(nodo_cuerpo.rotation.x), 0.1) # La función snnaped redondea a un decimal
			var deg_brazos = snapped(rad_to_deg(nodo_brazo_izq.rotation.x), 0.1)
			var deg_cabeza = snapped(rad_to_deg(nodo_cabeza.rotation.x), 0.1)
			print("Cuerpo: ", deg_cuerpo, "º | Brazos: ", deg_brazos, "º | Cabeza: ", deg_cabeza, "º")
			
	# Modo de la animación
	else:
		
		# Comenzamos la animación
		# 1º Bajamos a por el bloque
		if not bloque_cogido:
			
			# Movemos la cabeza
			if nodo_cabeza.rotation.x < deg_to_rad(34.9): # Le bajo una decima para que funcione no se por que xd
				
				# AQUI USAMOS LA FUNCIÓN: move_toward(valor_actual, valor_destino, paso), automaticamente suma o resta de uno en uno ha cierta velocidad
				# Hacerlo así es mucho más facil que hacerlo manualmente, por eso utilizo esa función.
				nodo_cabeza.rotation.x = move_toward(nodo_cabeza.rotation.x, deg_to_rad(35.0), Velocidad_giro/2 * delta)
				
			else: # Cuando acabe movemos el resto
			# Movemos el cuerpo junto con los brazos
				nodo_cuerpo.rotation.x = move_toward(nodo_cuerpo.rotation.x, deg_to_rad(35.0), Velocidad_giro/2 * delta)
				nodo_brazo_izq.rotation.x = move_toward(nodo_brazo_izq.rotation.x, deg_to_rad(-60.0), Velocidad_giro * delta)
				nodo_brazo_der.rotation.x = move_toward(nodo_brazo_der.rotation.x, deg_to_rad(-60.0), Velocidad_giro * delta)
		
				# Cuando se agache del todo encanchamos el bloque al cuerpo
				if nodo_cuerpo.rotation.x >= deg_to_rad(34.9) &&  nodo_brazo_izq.rotation.x <= deg_to_rad(-59.9):
					bloque.reparent(nodo_brazo_izq, true) # Lo enganchamos
					bloque_cogido = true
					print("TODO GUAY")
					 
					
		# 2º Nos levantamos con el bloque en la mano
		else: 
			# Movemos priemro el cuerpo y la cabeza a el estado de origen
			nodo_cuerpo.rotation.x = move_toward(nodo_cuerpo.rotation.x, deg_to_rad(0.0), Velocidad_giro/3 * delta)
			nodo_cabeza.rotation.x = move_toward(nodo_cabeza.rotation.x, deg_to_rad(0.0), Velocidad_giro/2 * delta)
			
			if  nodo_cuerpo.rotation.x == deg_to_rad(0.0) && nodo_cabeza.rotation.x == deg_to_rad(0.0):
				nodo_brazo_izq.rotation.x = move_toward(nodo_brazo_izq.rotation.x, deg_to_rad(-30.0), Velocidad_giro/2 * delta)
				nodo_brazo_der.rotation.x = move_toward(nodo_brazo_der.rotation.x, deg_to_rad(-30.0), Velocidad_giro/2 * delta)
			
			# Si el cuerpo llega a 0, la animación ha terminado
			if nodo_brazo_izq.rotation.x > deg_to_rad(-30.1):
				animando = false
				bloque_cogido = false # Reseteamos la variable por si queremos repetir el ciclo
				print("TODO GUAY2")
		
		
