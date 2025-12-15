extends Node2D

@export var texture_padrao: Texture2D

var current_color_index: int = 0
var colors: Array[Color] = [Color.RED, Color.BLUE, Color.GREEN, Color.YELLOW]

func _ready() -> void:
	if not texture_padrao:
		texture_padrao = load("res://icon.svg")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		current_color_index = (current_color_index + 1) % colors.size()
		queue_redraw()

func _draw() -> void:
	var color = colors[current_color_index]
	
	# Triângulo (contorno)
	var triangle_points = PackedVector2Array([Vector2(100, 50), Vector2(150, 150), Vector2(50, 150), Vector2(100, 50)])
	draw_polyline(triangle_points, color, 3.0)
	
	# Hexágono (gradiente por vértice)
	var hex_points = _get_polygon_points(6, 50, Vector2(300, 100))
	var hex_colors = PackedColorArray()
	for i in range(hex_points.size()):
		hex_colors.append(Color(randf(), randf(), randf()))
	draw_polygon(hex_points, hex_colors)
	
	# Estrela (com textura)
	var star_points = _get_star_points(5, 20, 50, Vector2(500, 100))
	var uvs = PackedVector2Array()
	for p in star_points:
		uvs.append((p - Vector2(450, 50)) / 100.0)
	draw_polygon(star_points, PackedColorArray([color]), uvs, texture_padrao)

func _get_polygon_points(sides: int, radius: float, center: Vector2) -> PackedVector2Array:
	var points = PackedVector2Array()
	for i in range(sides):
		var angle = deg_to_rad(i * 360.0 / sides)
		points.append(center + Vector2(cos(angle), sin(angle)) * radius)
	return points

func _get_star_points(points_count: int, inner_radius: float, outer_radius: float, center: Vector2) -> PackedVector2Array:
	var points = PackedVector2Array()
	var angle_step = PI / points_count
	for i in range(2 * points_count):
		var r = inner_radius if i % 2 != 0 else outer_radius
		var angle = i * angle_step
		points.append(center + Vector2(cos(angle), sin(angle)) * r)
	return points
