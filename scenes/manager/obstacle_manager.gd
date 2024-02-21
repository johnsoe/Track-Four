extends Node

@export var obstacles_to_spawn: Array[ObstacleModel]
@export var track_manager: TrackManager
@export var obstacle_count: int
@export var level_models: Array[LevelModel]

@onready var spawn_timer = $BasicSpawnTimer
@onready var level_timer = $LevelWaitTimer

var current_level_time: float = 0
var is_in_transition = false
var current_level = 1
var last_obstacles_track = []
var track_position_spawn = [1, -1, 1, -1]
var spawned_obstacle_count: int = 0
var obstacles_odds: Array[int] = []
 
func _process(delta):
	current_level_time += delta


func _ready():
	spawn_timer.wait_time = level_models[0].start_spawn_rate
	spawn_timer.timeout.connect(spawn_obstacle)
	level_timer.timeout.connect(level_wait_complete)
	Events.begin_level_transition.connect(on_level_transition)
	Events.complete_level_transition.connect(level_transition_complete)
	last_obstacles_track.resize(obstacle_count)
	obstacles_odds.assign(obstacles_to_spawn.map(func (obs): return obs.spawn_weight))


func spawn_obstacle():
	var level_model = level_models[current_level - 1]
	var level_spawn_timer_weight = clampf(current_level_time/level_model.spawn_rate_lerp_duration, 0, 1)
	spawn_timer.wait_time = lerp(level_model.start_spawn_rate, level_model.end_spawn_rate, level_spawn_timer_weight)
	if is_in_transition:
		return
		
	var track = get_random_track_from_dist()
	last_obstacles_track[spawned_obstacle_count % obstacle_count] = track
	var spawn_mode = level_models[current_level - 1].get_spawn_mode()
	
	if spawn_mode == ObstacleSpawnMode.ALL:
		for i in range(current_level + 1):
			var side = 1 if randi_range(0, 1) == 0 else -1
			spawn_obstacle_for_track(i, side, 0)
	elif spawn_mode == ObstacleSpawnMode.GAP:
		for i in range(2):
			var side = 1 if i == 0 else -1
			spawn_obstacle_for_track(track, side, 0)
	else:
		var prev_spawn = track_position_spawn[track]
		var side = prev_spawn if randi_range(0, 50) == 0 else prev_spawn * -1
		spawn_obstacle_for_track(track, side)
	
	spawned_obstacle_count += 1


func spawn_obstacle_for_track(track: int, side: int, obstacle_index: int = -1):
	var track_width = track_manager.get_track_width(current_level)
	var spawn_position = track_manager.get_track_spawn_position(track, current_level, TrackManager.LOCATION.TOP)
	var obstacle_inst: Obstacle2D
	if obstacle_index == -1:
		var index = pull_index_from_weighted_array(obstacles_odds)
		obstacle_inst = obstacles_to_spawn[index].obstacle_scene.instantiate() as Obstacle2D
	else:
		obstacle_inst = obstacles_to_spawn[obstacle_index].obstacle_scene.instantiate() as Obstacle2D

	get_parent().add_child(obstacle_inst)
	var offset = Vector2((track_width - obstacle_inst.width()) * side / 2.0, 0)
	obstacle_inst.global_position = spawn_position + offset
	if side == -1:
		obstacle_inst.flip()
	obstacle_inst.track = track
	track_position_spawn[track] = side


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
	spawn_timer.wait_time = level_models[current_level - 1].start_spawn_rate
	level_timer.start()

func level_wait_complete():
	is_in_transition = false
	current_level_time = 0
