extends Camera2D

# Definiowanie prędkości kamery
var speed = 500

func _process(delta):
	var movement = Vector2.ZERO

	# Sprawdzanie inputów klawiatury
	if Input.is_action_pressed("ui_right"):
		movement.x += 1
	if Input.is_action_pressed("ui_left"):
		movement.x -= 1
	if Input.is_action_pressed("ui_down"):
		movement.y += 1
	if Input.is_action_pressed("ui_up"):
		movement.y -= 1

	# Normalizacja wektora ruchu, żeby prędkość była stała we wszystkich kierunkach
	movement = movement.normalized() * speed

	# Aktualizowanie pozycji kamery
	position += movement * delta
