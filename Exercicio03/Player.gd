extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const ROTATION_SPEED = 2.0

# Referência à câmera: Arraste sua Camera3D para este campo no Inspetor.
# Para o exercício funcionar bem, a Câmera deve ser "filha" do Player ou estar em um Pivô que segue o Player.
@export var camera_ref: Camera3D 

func _physics_process(delta: float) -> void:
	# 1. Adicionar Gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta

	# 2. Pulo (Barra de espaço / Enter)
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# 3. Rotação da Câmera/Player com Setas 
	# O exercício pede "Rotação da câmera com setas esquerda/direita".
	# Giramos o Player. Se a câmera for filha dele, ela girará junto.
	var cam_rot = Input.get_axis("tecla_a", "tecla_d")
	if cam_rot:
		rotate_y(-cam_rot * ROTATION_SPEED * delta)

	# 4. Movimento relativo à direção da Câmera [cite: 220, 221]
	# Mapeamento solicitado: W/S (frente/trás), A/D (esquerda/direita)
	# get_vector(neg_x, pos_x, neg_y, pos_y)
	var input_dir := Input.get_vector("tecla_a", "tecla_d", "tecla_w", "tecla_s")
	
	var direction := Vector3.ZERO
	
	# Se tivermos uma câmera, movemos relativo a ela (para onde ela olha)
	if camera_ref:
		# Pega a base (orientação) da câmera
		var cam_basis = camera_ref.global_transform.basis
		# Cria a direção de movimento baseada na orientação da câmera
		# input_dir.x é lateral (A/D), input_dir.y é frente/trás (W/S)
		direction = (cam_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		# Removemos a inclinação em Y para o cubo não tentar "voar" ou "entrar" no chão ao olhar para cima/baixo
		direction.y = 0
		direction = direction.normalized()
	else:
		# Fallback caso a câmera não esteja atribuída: move relativo ao próprio Player
		direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
