extends Node
class_name TrackManager

enum LOCATION { TOP, BOTTOM }

@export var track_model: TrackModel
@export var top_spawn_offset_percent: float
@export var bottom_spawn_offset_percent: float
@export var camera_manager: CameraManager

@onready var tilemap: TrackTileMap = $TileMap

var mid_track_position: Dictionary

#TODO: consolidate logic in the tilemap and manager

func _ready():
	mid_track_position = {
		1: [0.0, 0.0],
		2: [0.0, 0.0, 0.0],
		3: [0.0, 0.0, 0.0, 0.0]
	}
	for i in range(1, 4):
		calculate_track_positions_by_level(i)
	
	print(mid_track_position)

func get_track_spawn_position(track: int, level: int, spawn_location: LOCATION):
	if track < 0 || track > mid_track_position.size() || level < 1 || level > 3:
		return null
		
	match spawn_location:
		LOCATION.BOTTOM: 
			return Vector2(mid_track_position[level][track], get_bottom_spawn_y())
		LOCATION.TOP:
			return Vector2(mid_track_position[level][track], get_top_spawn_y())


func get_top_spawn_y():
	var top_edge = camera_manager.camera_position() - camera_manager.calculate_camera_offset()
	var height = camera_manager.calculate_camera_offset().y * 2
	var top_spawn_offset = height * (top_spawn_offset_percent / 100.0)
	return top_edge.y - top_spawn_offset
	

func get_bottom_spawn_y():
	var bottom_edge = camera_manager.camera_position() + camera_manager.calculate_camera_offset()
	var height = camera_manager.calculate_camera_offset().y * 2
	var bottom_spawn_offset = height * (bottom_spawn_offset_percent / 100.0)
	return bottom_edge.y - bottom_spawn_offset


func calculate_track_positions_by_level(level: int):
	if level < 1 || level > 3:
		return
	var cell_size = tilemap.cell_quadrant_size
	var result = mid_track_position[level]
	match level:
		1: 
			result = [track_model.edge_buffer + (track_model.width_level_1 / 2.0), track_model.edge_buffer + (track_model.width_level_1 * 1.5) + 1]
		_:
			var w = track_model.width_level_2
			for i in range(0, level + 1):
				result[i] = i + 1 + (w * (.5 + i))
	
	mid_track_position[level] = result.map(func (num): return num * cell_size)
	

func get_track_width(level: int):
	if level < 1 || level > 3:
		return
		
	var base_width = 0.0
	match level:
		1: base_width = track_model.width_level_1
		2: base_width = track_model.width_level_2
		3: base_width = track_model.width_level_3
	
	return base_width * tilemap.cell_quadrant_size

func handle_level_update(level: int):
	pass
