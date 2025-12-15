extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const ROTATION_SPEED = 2.0

@export var camera_ref: Camera3D

func _physics_process(delta: float) -> void:
	# Gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Pulo
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Rotação horizontal com A/D
	var cam_rot = Input.get_axis("tecla_a", "tecla_d")
	if cam_rot:
		rotate_y(-cam_rot * ROTATION_SPEED * delta)

	# Direção de movimento relativa à câmera
	var input_dir := Input.get_vector("tecla_a", "tecla_d", "tecla_w", "tecla_s")
	var direction := Vector3.ZERO

	if camera_ref:
		var cam_basis = camera_ref.global_transform.basis
		direction = (cam_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	else:
		direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# Mantém o movimento sempre no plano horizontal
	direction.y = 0
	direction = direction.normalized()

	# Aplica velocidade horizontal
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
