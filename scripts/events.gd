extends Node

signal on_track_clicked(track: int)
signal on_swap_tracks(swaps: Dictionary)


func emit_on_track_clicked(track: int):
	on_track_clicked.emit(track)


func emit_on_swap_tracks(swaps: Dictionary):
	on_swap_tracks.emit(swaps)
