extends Node
class_name LevelManager

@export var distance_manager: DistanceManager
@export var track_manager: TrackManager

@export var level_thresholds: Array[int]
@export var level_portal_start: PackedScene
@export var level_portal_end: PackedScene

@export var ball_scene: PackedScene
@export var ball_sprites: Array[CompressedTexture2D]

var current_level = 0

func _ready():
	distance_manager.on_distance_updated.connect(handle_distance_update)
	Events.complete_level_transition.connect(handle_level_transition_complete)


func handle_distance_update(distance: int):
	# level_thresholds should only ever be size 2.
	if level_thresholds.size() != 2:
		return
	
	for x in range(0, level_thresholds.size()):
		if level_thresholds[x] == distance:
			Events.emit_begin_level_transition(x + 2)
			spawn_level_portals(x + 2)
		

func spawn_level_portals(lvl: int):
	for i in range(0, lvl):
		var portal = level_portal_start.instantiate()
		portal.global_position = track_manager.get_track_spawn_position(i, lvl - 1, TrackManager.LOCATION.TOP)
		get_parent().call_deferred("add_child", portal)
		portal.scale.x = 5 - lvl


func handle_level_transition_complete(lvl: int):
	current_level = lvl
	for i in range(0, lvl + 1):
		var portal = level_portal_end.instantiate()
		var track_position = track_manager.get_track_spawn_position(i, lvl, TrackManager.LOCATION.TOP)
		# TODO: Update this offset to be an export
		portal.global_position = track_position
		portal.track_id = i
		get_parent().call_deferred("add_child", portal)
		portal.scale.x = 4 - lvl
		portal.spawn_area_exited.connect(handle_end_portal_area_exited)


func spawn_ball_for_track(track: int):
	var track_position = track_manager.get_track_spawn_position(track, current_level, TrackManager.LOCATION.BOTTOM)
	var ball_inst = ball_scene.instantiate() as PlayerBall
	ball_inst.track_id = track
	ball_inst.sprite_override = ball_sprites[track]
	get_parent().call_deferred("add_child", ball_inst)
	ball_inst.global_position = track_position
	Events.emit_ball_spawn(ball_inst, track)


func handle_end_portal_area_exited(track_id: int):
	spawn_ball_for_track(track_id)


