extends Node

@export var balls: Array[Node2D]
@export var track_manager: TrackManager

var track_positions: Array[int]


func _ready():
	track_positions = [0, 1, 2, 3]
	Events.on_swap_tracks.connect(swap_tracks)


# Each swap is designed pair to denote 'from' and 'to' 
func swap_tracks(swaps: Dictionary):
	var old_positions = track_positions.duplicate()
	for key in swaps.keys():
		var from = key
		var to = swaps[key]
		track_positions[to] = old_positions[from]
	
	print(track_positions)
	update_ball_positions()	

func update_ball_positions():
	var y = balls[0].global_position.y
	for i in range(0, 2):
		var ball = balls[track_positions[i]]
		var x_position = track_manager.get_track_position(i)
		if x_position != null:
			ball.global_position = Vector2(x_position, y)
