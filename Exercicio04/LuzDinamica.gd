extends SpotLight3D

func _ready() -> void:
	light_energy = 6.0 # Garante que está forte o suficiente
	shadow_enabled = true

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# Muda a cor aleatoriamente [cite: 226]
		light_color = Color.from_hsv(randf(), randf(), randf(), randf())
		print("Nova cor da luz: ", light_color)
