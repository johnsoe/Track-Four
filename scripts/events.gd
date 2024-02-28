extends Node

signal on_track_clicked(track: int)
signal on_swap_tracks(swaps: Dictionary)
signal on_game_over(track: int)

signal begin_level_transition(level: int)
signal complete_level_transition(level: int)
signal ball_spawn(ball: Node2D, track_id: int)
signal on_obstacle_passed()


func emit_on_track_clicked(track: int):
	on_track_clicked.emit(track)


func emit_on_swap_tracks(swaps: Dictionary):
	on_swap_tracks.emit(swaps)


func emit_begin_level_transition(level: int):
	begin_level_transition.emit(level)


func emit_complete_level_transition(level: int):
	complete_level_transition.emit(level)


func emit_ball_spawn(ball: Node2D, track_id: int):
	ball_spawn.emit(ball, track_id)


func emit_game_over(track: int):
	on_game_over.emit(track)
	

func emit_obstacle_passed():
	on_obstacle_passed.emit()
