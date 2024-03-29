extends Node
class_name SwapManager

@export var balls: Array[Node2D]
@export var track_manager: TrackManager

var track_positions: Array[int]


func _ready():
	track_positions = [0, 1, 2, 3]
	Events.on_swap_tracks.connect(swap_tracks)
	Events.ball_spawn.connect(register_ball_spawn)


# Each swap is designed pair to denote 'from' and 'to' 
func swap_tracks(swaps: Dictionary):
	var old_positions = track_positions.duplicate()
	for key in swaps.keys():
		var from = key
		var to = swaps[key]
		track_positions[to] = old_positions[from]
	
	update_ball_positions()

func update_ball_positions():
	for i in range(0, 2):
		var ball = balls[track_positions[i]]
		var updated_position = track_manager.get_track_spawn_position(i, 1, TrackManager.LOCATION.BOTTOM)
		ball.global_position = updated_position


func register_ball_spawn(ball: Node2D, track_id: int):
	if track_id > balls.size():
		return
		
	balls[track_id] = ball
