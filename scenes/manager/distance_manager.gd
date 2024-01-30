extends Node
class_name DistanceManager

signal on_distance_updated(distance: int)

@onready var timer = $Timer
var distance = 0


func _ready():
	timer.timeout.connect(on_timeout)


func on_timeout():
	distance += 1
	on_distance_updated.emit(distance)
