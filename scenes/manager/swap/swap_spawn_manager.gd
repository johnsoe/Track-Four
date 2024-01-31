extends Node

@export var swap_thresholds: Array[int]
@export var distance_manager: DistanceManager
@export var track_manager: TrackManager
@export var swap_scene: PackedScene
@export var camera_manager: CameraManager

var camera_position_offset: Vector2
var required_swap_count: int
var next_swaps: Dictionary

func _ready():
	camera_position_offset = camera_manager.calculate_camera_offset()
	distance_manager.on_distance_updated.connect(on_distance_updated)


func on_distance_updated(distance: int):
	return 
	
	if swap_thresholds.any(func(number): return distance == number):
		# determine which tracks to swap, then spawn swap scene.
		pass
	
	#Absolute hack to test this is working
	if distance == 1:
		required_swap_count = 2
		next_swaps = {}
		
		var portal = swap_scene.instantiate() as Portal
		var x = (track_manager.get_track_spawn_position(0, TrackManager.LOCATION.TOP)).x - 19
		var y = (camera_manager.camera_position() - camera_position_offset - Vector2(0, 200)).y
		portal.global_position = Vector2(x, y)
		get_parent().add_child(portal)
		portal.set_swap(Vector2(0, 1))
		portal.on_player_collide.connect(register_swap)
		
		portal = swap_scene.instantiate() as Portal
		x = (track_manager.get_track_spawn_position(0, TrackManager.LOCATION.TOP)).x - 29
		y = (camera_manager.camera_position() - camera_position_offset - Vector2(0, 200)).y
		portal.global_position = Vector2(x, y)
		get_parent().add_child(portal)
		portal.set_swap(Vector2(1, 0))
		portal.on_player_collide.connect(register_swap)


func register_swap(swap: Vector2):
	next_swaps[swap.x] = swap.y
	if (next_swaps.size() == required_swap_count):
		Events.emit_on_swap_tracks(next_swaps.duplicate())
