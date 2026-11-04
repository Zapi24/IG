extends Node3D

@export var incremento := 3 # La velocidad angular en rad/s

func _process(delta):
	var angulo := 0.0
	
	if Input.is_action_pressed("orbitar_izquierda"):
		angulo -= incremento * delta
	elif Input.is_action_pressed("orbitar_derecha"):
		angulo += incremento * delta
	rotate_y(angulo)
