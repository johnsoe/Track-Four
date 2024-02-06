extends Node


@export var basic_obstacle: PackedScene
@export var long_obstacle: PackedScene
@export var obstacle_odds: Array[int]
@export var track_manager: TrackManager
@export var obstacle_count: int

@onready var spawn_timer = $BasicSpawnTimer
@onready var level_timer = $LevelWaitTimer

var is_in_transition = false
var current_level = 1
var last_obstacles_track = []
var spawned_obstacle_count: int = 0
 

func _ready():
	spawn_timer.timeout.connect(spawn_obstacle)
	level_timer.timeout.connect(level_wait_complete)
	Events.begin_level_transition.connect(on_level_transition)
	Events.complete_level_transition.connect(level_transition_complete)
	last_obstacles_track.resize(obstacle_count)


func spawn_obstacle():
	if is_in_transition:
		return
		
	var track = get_random_track_from_dist()
	last_obstacles_track[spawned_obstacle_count % obstacle_count] = track
	var spawn_position = track_manager.get_track_spawn_position(track, current_level, TrackManager.LOCATION.TOP)
	var track_width = track_manager.get_track_width(current_level)
	var side = -1 if randi_range(0, 1) == 0 else 1
		
	var obstacle_inst = instantiate_random_obstacle()
	get_parent().add_child(obstacle_inst)
	obstacle_inst.global_position = spawn_position + Vector2((track_width - obstacle_inst.width()) * side / 2.0, 0)
	if side == -1:
		obstacle_inst.flip()
	spawned_obstacle_count += 1


func instantiate_random_obstacle():
	var index = pull_index_from_weighted_array(obstacle_odds)
	match index:
		1:
			return long_obstacle.instantiate() as Obstacle2D
		_:
			return basic_obstacle.instantiate() as Obstacle2D
	


func on_level_transition(level: int):
	is_in_transition = true


func get_random_track_from_dist():
	var dist = get_obstacle_distribution() as Array[int]
	var priority = dist.find(-1)
	if priority != -1:
		return priority
	
	return pull_index_from_weighted_array(dist)


func pull_index_from_weighted_array(arr):
	var sum = arr.reduce(func(accum, num): return accum + num, 0)
	var temp_sum = 0
	var num = randi_range(0, sum - 1)
	for i in arr.size():
		temp_sum += arr[i]
		if num <= temp_sum:
			return i
	return 0

func get_obstacle_distribution():
	var distribution = []
	distribution.resize(current_level + 1)
	for i in range(0, current_level + 1):
		distribution[i] = obstacle_count - last_obstacles_track.count(i)
	return distribution


func level_transition_complete(level: int):
	current_level = level
	level_timer.start()

func level_wait_complete():
	is_in_transition = false
