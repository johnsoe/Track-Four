extends Node

@export var obstacles_to_spawn: Array[ObstacleModel]
@export var level_timing: Array[float]
@export var track_manager: TrackManager
@export var obstacle_count: int

@onready var spawn_timer = $BasicSpawnTimer
@onready var level_timer = $LevelWaitTimer

var is_in_transition = false
var current_level = 1
var last_obstacles_track = []
var track_position_spawn = [1, -1, 1, -1]
var spawned_obstacle_count: int = 0
var obstacles_odds: Array[int] = []
 

func _ready():
	spawn_timer.wait_time = level_timing[0]
	spawn_timer.timeout.connect(spawn_obstacle)
	level_timer.timeout.connect(level_wait_complete)
	Events.begin_level_transition.connect(on_level_transition)
	Events.complete_level_transition.connect(level_transition_complete)
	last_obstacles_track.resize(obstacle_count)
	obstacles_odds.assign(obstacles_to_spawn.map(func (obs): return obs.spawn_weight))
	


func spawn_obstacle():
	if is_in_transition:
		return
		
	var track = get_random_track_from_dist()
	last_obstacles_track[spawned_obstacle_count % obstacle_count] = track
	var spawn_position = track_manager.get_track_spawn_position(track, current_level, TrackManager.LOCATION.TOP)
	var track_width = track_manager.get_track_width(current_level)
	
		
	var obstacle_inst = instantiate_random_obstacle()
	get_parent().add_child(obstacle_inst)
	var offset = Vector2.ZERO
	if obstacle_inst.is_offset:
		var prev_spawn = track_position_spawn[track]
		if prev_spawn == 0:
			prev_spawn = -1
		var side = prev_spawn if randi_range(0, 6) == 0 else prev_spawn * -1
		track_position_spawn[track] = side
		offset = Vector2((track_width - obstacle_inst.width()) * side / 2.0, 0)
		if side == -1:
			obstacle_inst.flip()
	else:
		track_position_spawn[track] = 0
		
	obstacle_inst.global_position = spawn_position + offset
	spawned_obstacle_count += 1


func instantiate_random_obstacle():
	var index = pull_index_from_weighted_array(obstacles_odds)
	return obstacles_to_spawn[index].obstacle_scene.instantiate() as Obstacle2D


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
	spawn_timer.wait_time = level_timing[current_level - 1]
	level_timer.start()

func level_wait_complete():
	is_in_transition = false
