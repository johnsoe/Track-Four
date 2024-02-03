extends Node


@export var basic_obstacle: PackedScene
@export var track_manager: TrackManager
@onready var spawn_timer = $BasicSpawnTimer
@onready var level_timer = $LevelWaitTimer

var is_in_transition = false
var current_level = 1

func _ready():
	spawn_timer.timeout.connect(spawn_obstacle)
	level_timer.timeout.connect(level_wait_complete)
	Events.begin_level_transition.connect(on_level_transition)
	Events.complete_level_transition.connect(level_transition_complete)


func spawn_obstacle():
	if is_in_transition:
		return
	var track = randi_range(0, current_level)
	var spawn_position = track_manager.get_track_spawn_position(track, current_level, TrackManager.LOCATION.TOP)
	var track_width = track_manager.get_track_width(current_level)
	var side = -1 if randi_range(0, 1) == 0 else 1
		
	var obstacle_inst = basic_obstacle.instantiate() as Obstacle2D
	get_parent().add_child(obstacle_inst)
	obstacle_inst.global_position = spawn_position + Vector2((track_width - obstacle_inst.width()) * side / 2.08, 0)
	if side == -1:
		obstacle_inst.flip()


func on_level_transition(level: int):
	is_in_transition = true


func level_transition_complete(level: int):
	current_level = level
	level_timer.start()

func level_wait_complete():
	is_in_transition = false
