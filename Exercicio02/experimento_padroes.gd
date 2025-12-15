extends Node2D

@export var texture_listras: Texture2D
@export var texture_pontos: Texture2D

var current_texture: Texture2D
var tiles_x: int = 2
var tiles_y: int = 2

func _ready() -> void:
	current_texture = texture_listras

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("tecla_1"):
		current_texture = texture_listras
		queue_redraw()
	elif event.is_action_pressed("tecla_2"):
		current_texture = texture_pontos
		queue_redraw()
	
	if event.is_action_pressed("ui_up"):
		tiles_x += 1
		queue_redraw()
	if event.is_action_pressed("ui_down"):
		tiles_x = max(1, tiles_x - 1)
		queue_redraw()

func _draw() -> void:
	if not current_texture:
		return
	
	var rect_size := Vector2(200, 200)
	var pos := Vector2(100, 100)
	var tile_w := rect_size.x / tiles_x
	var tile_h := rect_size.y / tiles_y
	
	for i in tiles_x:
		for j in tiles_y:
			var tile_pos := pos + Vector2(i * tile_w, j * tile_h)
			var tile_rect := Rect2(tile_pos, Vector2(tile_w, tile_h))
			draw_texture_rect(current_texture, tile_rect, true)
