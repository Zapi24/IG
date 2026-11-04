extends Node3D

var dibujar_aristas: bool = false
@onready var camera_pivot: Node3D = $PivoteCamara

func _init():
	RenderingServer.set_debug_generate_wireframes(true)
	
	
# Para el movimiento de la camara
func _process(delta):	
	var velocidad_rotacion = 2.0
	
	if Input.is_key_pressed(KEY_LEFT):
		camera_pivot.rotate_y(-velocidad_rotacion * delta)
	if Input.is_key_pressed(KEY_RIGHT):
		camera_pivot.rotate_y(velocidad_rotacion * delta)

# Revisa cualquier tecla que se pulse que no sea identificada por otro script
func _unhandled_key_input(key_event):
	if key_event.keycode == KEY_W and not key_event.pressed:
			dibujar_aristas = not dibujar_aristas
			var viewport = get_viewport()
			
			if dibujar_aristas:
				viewport.debug_draw = Viewport.DEBUG_DRAW_WIREFRAME
				print("Modo aristas: activado")
			else:
				viewport.debug_draw = Viewport.DEBUG_DRAW_DISABLED
				print("Modo aristas: desactivado")
