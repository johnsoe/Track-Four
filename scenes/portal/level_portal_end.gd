extends Node2D

signal spawn_area_exited(track_id: int)

@onready var area = $Area2D
var track_id = -1

func _ready():
	area.area_exited.connect(on_area_exited)


func on_area_exited(area: Area2D):
	spawn_area_exited.emit(track_id)
	queue_free()
