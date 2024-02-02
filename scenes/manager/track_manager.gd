extends Node
class_name TrackManager

enum LOCATION { TOP, BOTTOM }
enum DRAW_MODE { STANDARD, TRANSITION }

@export var track_model: TrackModel
@export var top_spawner: Node2D
@export var bottom_spawner: Node2D

@onready var tilemap: TrackTileMap = $TileMap

var mid_track_position: Dictionary
var current_level: int = 1

func _ready():
	tilemap.transition_complete.connect(handle_transition_complete)
	Events.begin_level_transition.connect(handle_level_update)
	mid_track_position = {
		1: [0.0, 0.0],
		2: [0.0, 0.0, 0.0],
		3: [0.0, 0.0, 0.0, 0.0]
	}
	for i in range(1, 4):
		calculate_track_positions_by_level(i)
	

func get_track_spawn_position(track: int, level: int, spawn_location: LOCATION):
	if track < 0 || track > mid_track_position.size() || level < 1 || level > 3:
		return null
		
	match spawn_location:
		LOCATION.BOTTOM: 
			return Vector2(mid_track_position[level][track], get_bottom_spawn_y())
		LOCATION.TOP:
			return Vector2(mid_track_position[level][track], get_top_spawn_y())


func get_top_spawn_y():
	return top_spawner.global_position.y
	

func get_bottom_spawn_y():
	return bottom_spawner.global_position.y


func calculate_track_positions_by_level(level: int):
	if level < 1 || level > 3:
		return
	var cell_size = tilemap.cell_quadrant_size
	var result = mid_track_position[level]
	match level:
		1: 
			result = [track_model.edge_buffer + (track_model.width_level_1 / 2.0), track_model.edge_buffer + (track_model.width_level_1 * 1.5) + 1]
		_:
			var w = track_model.width_by_level(level)
			for i in range(0, level + 1):
				result[i] = i + 1 + (w * (.5 + i))
	
	mid_track_position[level] = result.map(func (num): return num * cell_size)
	

func get_track_width(level: int):	
	return track_model.width_by_level(level) * tilemap.cell_quadrant_size


func handle_level_update(level: int):
	current_level = level


func handle_transition_complete():
	Events.emit_complete_level_transition(current_level)
	
