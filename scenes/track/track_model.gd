extends Resource
class_name TrackModel

@export var width_level_1: int
@export var width_level_2: int
@export var width_level_3: int
@export var edge_buffer: int


func width_by_level(level: int):
	if level < 1 || level > 3:
		return
	
	match level:
		1: return width_level_1
		2: return width_level_2
		3: return width_level_3
