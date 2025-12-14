extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const ROTATION_SPEED = 2.0

# Referência à câmera (Arraste a câmera para este slot no inspetor se ela não for filha direta)
@export var camera_ref: Camera3D 

func _physics_process(delta: float) -> void:
	# 1. Adicionar Gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta

	# 2. Pulo
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# 3. Rotação da Câmera (Exercício pede setas esquerda/direita) [cite: 220]
	# Se a câmera for filha do Player, girar o Player gira a câmera junto.
	# Se a câmera for independente, giramos ela. 
	# Assumindo câmera como FILHA para simplicidade do slide 23 (First/Third person simples):
	var cam_rot = Input.get_axis("ui_left", "ui_right")
	if cam_rot:
		rotate_y(-cam_rot * ROTATION_SPEED * delta)

	# 4. Movimento relativo à câmera
	# Obtemos o input (WASD)
	# Nota: Como usamos ui_left/right para girar a câmera, usaremos ui_up/down para andar frente/trás
	# Ou definimos novas teclas para andar lateralmente (strafe).
	var input_dir := Input.get_vector("tecla_a", "tecla_d", "ui_up", "ui_down") # Defina A e D no InputMap para strafe
	
	# Transforma o input local em direção global baseada na orientação atual do Player (já que giramos ele acima)
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
