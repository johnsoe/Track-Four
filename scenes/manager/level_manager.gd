extends Node
class_name LevelManager

@export var distance_manager: DistanceManager
@export var track_manager: TrackManager

@export var level_thresholds: Array[int]
@export var level_portal_start: PackedScene
@export var level_portal_end: PackedScene

@export var ball_scene: PackedScene
@export var ball_sprites: Array[CompressedTexture2D]

var portal_end_data = Vector2.ZERO

func _ready():
	distance_manager.on_distance_updated.connect(handle_distance_update)
	Events.complete_level_transition.connect(handle_level_transition_complete)


func _process(delta):
	if portal_end_data == Vector2.ZERO:
		return
	
	if portal_end_data.y > track_manager.get_bottom_spawn_y():
		spawn_balls(portal_end_data.x)
		portal_end_data = Vector2.ZERO

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
		get_parent().add_child(portal)
		portal.scale.x = 5 - lvl


func handle_level_transition_complete(lvl: int):
	for i in range(0, lvl + 1):
		var portal = level_portal_end.instantiate()
		var track_position = track_manager.get_track_spawn_position(i, lvl, TrackManager.LOCATION.TOP)
		# TODO: Update this offset to be an export
		portal.global_position = track_position - Vector2(0, 10)
		get_parent().add_child(portal)
		portal.scale.x = 4 - lvl
		portal_end_data = Vector2(lvl, portal.global_position.y)


func spawn_balls(lvl: int):
	for i in range(0, lvl + 1):
		var track_position = track_manager.get_track_spawn_position(i, lvl, TrackManager.LOCATION.BOTTOM)
		var ball_inst = ball_scene.instantiate() as PlayerBall
		ball_inst.track_id = i
		ball_inst.sprite_override = ball_sprites[i]
		ball_inst.vert_speed = 200
		ball_inst.x_speed = 400
		get_parent().add_child(ball_inst)
		ball_inst.global_position = track_position
		Events.emit_ball_spawn(ball_inst, i)


