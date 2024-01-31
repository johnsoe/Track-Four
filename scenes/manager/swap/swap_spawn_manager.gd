extends Node

@export var swap_thresholds: Array[int]
@export var distance_manager: DistanceManager
@export var track_manager: TrackManager
@export var swap_scene: PackedScene

#TODO: consolidate camera position logic
var camera: Camera2D
var required_swap_count: int
var next_swaps: Dictionary

func _ready():
	camera = get_tree().get_first_node_in_group("camera") as Camera2D
	if camera == null:
		return
	
	distance_manager.on_distance_updated.connect(on_distance_updated)


func on_distance_updated(distance: int):
	if swap_thresholds.any(func(number): return distance == number):
		# determine which tracks to swap, then spawn swap scene.
		pass
	
	#Absolute hack to test this is working
	if distance == 1:
		required_swap_count = 2
		next_swaps = {}
		
		var camera_viewport_pos = camera.get_viewport().get_visible_rect().position
		var camera_pos = camera.global_position
		var camera_position_offset = camera_pos - camera_viewport_pos
		
		var portal = swap_scene.instantiate() as Portal
		var x = track_manager.get_track_position(0) - 19
		var y = (camera.global_position - camera_position_offset - Vector2(0, 200)).y
		portal.global_position = Vector2(x, y)
		get_parent().add_child(portal)
		portal.set_swap(Vector2(0, 1))
		portal.on_player_collide.connect(register_swap)
		
		portal = swap_scene.instantiate() as Portal
		x = track_manager.get_track_position(1) - 29
		y = (camera.global_position - camera_position_offset - Vector2(0, 200)).y
		portal.global_position = Vector2(x, y)
		get_parent().add_child(portal)
		portal.set_swap(Vector2(1, 0))
		portal.on_player_collide.connect(register_swap)
		

func register_swap(swap: Vector2):
	next_swaps[swap.x] = swap.y
	if (next_swaps.size() == required_swap_count):
		Events.emit_on_swap_tracks(next_swaps.duplicate())
