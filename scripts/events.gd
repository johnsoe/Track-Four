extends Node

signal on_track_clicked(track: int)


func emit_on_track_clicked(track: int):
	on_track_clicked.emit(track)
