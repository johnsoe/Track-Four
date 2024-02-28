extends Node

@export var swap_thresholds: Array[int]
@export var distance_manager: DistanceManager
@export var track_manager: TrackManager
@export var swap_scene: PackedScene
@export var camera_manager: CameraManager

var required_swap_count: int
var next_swaps: Dictionary

# DO NOT CALL
func on_distance_updated(distance: int):
	if swap_thresholds.any(func(number): return distance == number):
		# determine which tracks to swap, then spawn swap scene.
		pass
	
	#Absolute hack to test this is working
	if distance == 1:
		required_swap_count = 2
		next_swaps = {}
		
		#TODO: Dynamically size portals based on tracks
		var portal = swap_scene.instantiate() as Portal
		portal.global_position = track_manager.get_track_spawn_position(0, 1, TrackManager.LOCATION.TOP)
		get_parent().add_child(portal)
		portal.scale.x = 3
		portal.set_swap(Vector2(0, 1))
		portal.on_player_collide.connect(register_swap)
		
		portal = swap_scene.instantiate() as Portal
		portal.global_position = track_manager.get_track_spawn_position(1, 1, TrackManager.LOCATION.TOP)
		portal.scale.x = 3
		get_parent().add_child(portal)
		portal.set_swap(Vector2(1, 0))
		portal.on_player_collide.connect(register_swap)


func register_swap(swap: Vector2):
	next_swaps[swap.x] = swap.y
	if (next_swaps.size() == required_swap_count):
		Events.emit_on_swap_tracks(next_swaps.duplicate())
