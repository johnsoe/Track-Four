extends TileMap
class_name TrackTileMap

signal transition_complete()

@export var atlas_x_start: int
@export var track_model: TrackModel
@export var cracked_tile_odds: int
@export var top_spawner: Node2D
@export var object_eraser: Node2D
@export var pan_speed: int
@export var debug_label: Label

var top_draw_row: int
var bottom_erase_row: int

var total_width: int
var current_width: int
var edge_buffer: int

var draw_mode: TrackManager.DRAW_MODE
var prev_draw_mode: TrackManager.DRAW_MODE

func _ready():
	top_draw_row = 0
	current_width = track_model.width_level_1
	edge_buffer = track_model.edge_buffer
	total_width = (current_width * 2) + 1 + (edge_buffer * 2)
	Events.begin_level_transition.connect(handle_level_update)


func _process(delta):
	var top_spawner_coords = local_to_map(to_local(top_spawner.global_position))
	var row = top_spawner_coords.y
	
	var bottom_spawner_coords = local_to_map(to_local(object_eraser.global_position))
	var bottom_row = bottom_spawner_coords.y
	
	if (row < top_draw_row):
		draw_next_row(row)
	
	if (bottom_erase_row > bottom_row):
		erase_bottom_row(bottom_erase_row)


func draw_next_row(row: int):
	match draw_mode:
		TrackManager.DRAW_MODE.STANDARD:
			draw_standard_row(row)
		TrackManager.DRAW_MODE.TRANSITION:
			if prev_draw_mode == TrackManager.DRAW_MODE.TRANSITION:
				draw_mode = TrackManager.DRAW_MODE.STANDARD
				transition_complete.emit()
			else:
				draw_transition_block(row)
	prev_draw_mode = draw_mode


func draw_standard_row(row: int): 
	top_draw_row = row
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
			if randi() % cracked_tile_odds == 0:
				var offset = randi() % 3 + 2
				atlas_coords = Vector2i(atlas_x_start + 1 + (track * 6), 9 - offset)
			else:
				atlas_coords = Vector2i(atlas_x_start + 1 + (track * 6), 9)
		set_cell(0, Vector2i(x + edge_buffer, row), 0, atlas_coords)


func draw_transition_block(row: int):
	top_draw_row -= 9
	
	for y in range(row, row - 4, -1):
		set_row_as_barrier(y)
	
	#gap for skybox
	for y in range(row - 8, row - 12, -1):
		set_row_as_barrier(y)


func set_row_as_barrier(row: int):
	var barrier_atlas = Vector2i(10, 14)
	for x in range(0, total_width):
		set_cell(0, Vector2i(x, row), 0, barrier_atlas)


func erase_bottom_row(row: int):
	bottom_erase_row -= 1
	for x in range(0, total_width):
		erase_cell(0, Vector2i(x, row))


func _input(event):
	if event is InputEventScreenTouch && event.is_pressed():
		debug_label.text = str(event.index) + " " + str(event.position)
		var position = event.position
		var tile_clicked = local_to_map(to_local(position))
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
	draw_mode = TrackManager.DRAW_MODE.TRANSITION
	edge_buffer = 1
	match level:
		2: current_width = track_model.width_level_2
		3: current_width = track_model.width_level_3
