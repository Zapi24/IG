extends Node3D

var dibujar_aristas: bool = false # Para controlar si las aristas estan dibujadaas o no

func _init():
	RenderingServer.set_debug_generate_wireframes(true)

# Revisa cualquier tecla que se pulse que no sea identificada por otro script
func _unhandled_key_input(key_event):

	# Detectamos si pulsamos la W (no si se mantiene pulsada)
	if key_event.keycode == KEY_W and not key_event.pressed:
		
		dibujar_aristas = not dibujar_aristas # Intervimos valor
		
		# Obtenemos la pantalla actual (viewport)
		var viewport = get_viewport()
		
		if dibujar_aristas:
			viewport.debug_draw = Viewport.DEBUG_DRAW_WIREFRAME
			print("Dibujar en modo aristas: activado")
		else:
			viewport.debug_draw = Viewport.DEBUG_DRAW_DISABLED
			print("Dibujar en modo aristas: desactivado")
