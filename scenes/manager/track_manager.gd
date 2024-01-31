extends Node
class_name TrackManager

enum LOCATION { TOP, BOTTOM }

@export var track_model: TrackModel
@export var ball_spawn_height_percent: float
@export var camera_manager: CameraManager

@onready var tilemap: TrackTileMap = $TileMap

var mid_track_position: Array[float]
var tile_width: int

#TODO: consolidate logic in the tilemap and manager

func _ready():
	mid_track_position = [0.0, 0.0, 0.0, 0.0]
	tile_width = track_model.width_level_1
	for i in range(0, 4):
		mid_track_position[i] = calculate_track_position(i)
	
	Events.complete_level_animation.connect(handle_level_update)
	

func get_track_spawn_position(track: int, spawn_location: LOCATION):
	if track < 0 || track > mid_track_position.size():
		return null
		
	match spawn_location:
		LOCATION.BOTTOM: 
			return Vector2(mid_track_position[track], get_bottom_spawn_y())
		LOCATION.TOP:
			return Vector2(mid_track_position[track], get_top_spawn_y())


func get_top_spawn_y():
	camera_manager.get_camera_rect().position.y
	

func get_bottom_spawn_y():
	var rect = camera_manager.get_camera_rect() as Rect2
	var height = rect.end.y - rect.position.y
	var bottom_spawn_offset = height * (ball_spawn_height_percent / 100.0)
	return camera_manager.get_camera_rect().end.y - bottom_spawn_offset


func calculate_track_position(track: int):
	var x_coord = get_mid_x_of_track(track)
	var global_x_coord = tilemap.map_to_local(Vector2(x_coord, 0)).x
	return global_x_coord


func get_mid_x_of_track(track: int):
	var width = tile_width
	return (width * track) + (width / 2) + track
	

func handle_level_update(level: int):
	match level:
		2: tile_width = track_model.width_level_2
		3: tile_width = track_model.width_level_3
		
	for i in range(0, 4):
		mid_track_position[i] = calculate_track_position(i)
