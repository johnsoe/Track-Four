extends TileMap
class_name TrackTileMap

@export var vertical_offset: int
@export var tileset_width: int
@export var atlas_x_start: int

var camera_position_offset: Vector2
var last_draw_row: int
var camera: Camera2D

func _ready():
	last_draw_row = 0
	camera = get_tree().get_first_node_in_group("camera") as Camera2D
	if camera == null:
		return
		
	var camera_viewport_pos = camera.get_viewport().get_visible_rect().position
	var camera_pos = camera.global_position
	camera_position_offset = camera_pos - camera_viewport_pos
	

func _process(delta):
	var top_camera_map_coords = local_to_map(camera.global_position - camera_position_offset)
	var row = top_camera_map_coords.y - vertical_offset
	
	var bottom_camera_map_coords = local_to_map(camera.global_position + camera_position_offset)
	var bottom_row = bottom_camera_map_coords.y + vertical_offset
	
	if (row < last_draw_row):
		draw_next_row(row)
		erase_bottom_row(bottom_row)


func draw_next_row(row: int):
	last_draw_row = row
	set_cell(0, Vector2i(-1, row), 1, Vector2i(10, 14))
	for x in range(0, tileset_width * 4):
		var track = x / tileset_width
		var atlas_coords: Vector2i
		if x % tileset_width == 0:
			atlas_coords = Vector2i(atlas_x_start + (track * 6), 9)
		elif x % tileset_width == tileset_width - 1:
			atlas_coords = Vector2i(10, 14)
		elif x % tileset_width == tileset_width - 2:
			atlas_coords = Vector2i(atlas_x_start + 2 + (track * 6), 9)
		else:
			atlas_coords = Vector2i(atlas_x_start + 1 + (track * 6), 9)
		set_cell(0, Vector2i(x, row), 1, atlas_coords)


func erase_bottom_row(row: int):
	for x in range(0, tileset_width * 4):
		erase_cell(0, Vector2i(x, row))


func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			var position = event.position
			var tile_clicked = local_to_map(position)
			var track = tile_clicked.x / tileset_width
			Events.on_track_clicked.emit(track)
