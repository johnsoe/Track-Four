extends Resource
class_name LevelModel

@export var start_spawn_rate: float
@export var end_spawn_rate: float
@export var spawn_rate_lerp_duration: float
@export var level_duration: float

@export var gap_obstacle_spawn_chance: float
@export var all_obstacle_spawn_chance: float


func get_spawn_mode():
	var random = randf_range(0, 1)
	if random < gap_obstacle_spawn_chance:
		return ObstacleSpawnMode.GAP
	elif random < all_obstacle_spawn_chance + gap_obstacle_spawn_chance:
		return ObstacleSpawnMode.ALL
	else:
		return ObstacleSpawnMode.DEFAULT
