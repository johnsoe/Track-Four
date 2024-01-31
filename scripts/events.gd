extends Node

signal on_track_clicked(track: int)
signal on_swap_tracks(swaps: Dictionary)

signal begin_level_animation(level: int)
signal complete_level_animation(level: int)


func emit_on_track_clicked(track: int):
	on_track_clicked.emit(track)


func emit_on_swap_tracks(swaps: Dictionary):
	on_swap_tracks.emit(swaps)


func emit_begin_level_animation(level: int):
	begin_level_animation.emit(level)


func emit_complete_level_animation(level: int):
	complete_level_animation.emit(level)
