extends TileMap
class_name TrackTileMap

@export var vertical_offset: int
@export var atlas_x_start: int
@export var track_model: TrackModel
@export var camera_manager: CameraManager

var camera_position_offset: Vector2
var last_draw_row: int

var total_width: int
var target_width: int
var current_width: int
var edge_buffer: int

func _ready():
	last_draw_row = 0

	camera_position_offset = camera_manager.calculate_camera_offset()
	current_width = track_model.width_level_1
	target_width = current_width
	edge_buffer = track_model.edge_buffer
	total_width = (current_width * 2) + 1 + (edge_buffer * 2)
	
	Events.begin_level_animation.connect(handle_level_update)


func _process(delta):
	var top_camera_map_coords = local_to_map(camera_manager.camera_position() - camera_position_offset)
	var row = top_camera_map_coords.y - vertical_offset
	
	var bottom_camera_map_coords = local_to_map(camera_manager.camera_position() + camera_position_offset)
	var bottom_row = bottom_camera_map_coords.y + vertical_offset
	
	if (row < last_draw_row):
		draw_next_row(row)
		erase_bottom_row(bottom_row)


func draw_next_row(row: int):
	last_draw_row = row
	var barrier_atlas = Vector2i(10, 14)
	for x in range(0, edge_buffer):
		set_cell(0, Vector2i(x, row), 0, barrier_atlas)
	
	for x in range(total_width - edge_buffer, total_width):
		set_cell(0, Vector2i(x, row), 0, barrier_atlas)	
	
	for x in range(0, total_width - (edge_buffer * 2)):
		var track = x / (current_width + 1)
		var atlas_coords: Vector2i
		if x % (current_width + 1) == 0:
			atlas_coords = Vector2i(atlas_x_start + (track * 6), 9)
		elif x % (current_width + 1) == current_width:
			atlas_coords = barrier_atlas
		elif x % (current_width + 1) == current_width - 1:
			atlas_coords = Vector2i(atlas_x_start + 2 + (track * 6), 9)
		else:
			atlas_coords = Vector2i(atlas_x_start + 1 + (track * 6), 9)
		set_cell(0, Vector2i(x + edge_buffer, row), 0, atlas_coords)


func erase_bottom_row(row: int):
	for x in range(0, total_width):
		erase_cell(0, Vector2i(x, row))


func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			var position = get_global_mouse_position()
			var tile_clicked = local_to_map(position)
			var tile_data = get_cell_tile_data(0, tile_clicked)
			if tile_data == null:
				return
				
			var track_id = tile_data.get_custom_data("track_id")
			# This is dirty hack for now
			if tile_clicked.x == 0:
				var dict = {0:1, 1:0}
				Events.on_swap_tracks.emit(dict)
			else:
				Events.on_track_clicked.emit(track_id)


func handle_level_update(level: int):
	edge_buffer = 1
	match level:
		2: current_width = track_model.width_level_2
		3: current_width = track_model.width_level_3
