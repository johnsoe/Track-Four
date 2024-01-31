extends Node
class_name LevelManager

@export var distance_manager: DistanceManager
@export var level_thresholds: Array[int]

func _ready():
	distance_manager.on_distance_updated.connect(handle_distance_update)


func handle_distance_update(distance: int):
	# level_thresholds should only ever be size 2.
	if level_thresholds.size() != 2:
		return
		
	
	# Hard coded level values, not ideal.
	if level_thresholds[0] == distance:
		Events.emit_begin_level_animation(2)
	elif level_thresholds[1] == distance:
		Events.emit_begin_level_animation(3)
		
