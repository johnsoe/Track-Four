extends Node

@export var swap_thresholds: Array[int]
@export var distance_manager: DistanceManager
@export var swap_scene: PackedScene

func _ready():
	distance_manager.on_distance_updated.connect(on_distance_updated)


func on_distance_updated(distance: int):
	if swap_thresholds.any(func(number): return distance == number):
		# determine which tracks to swap, then spawn swap scene.
		pass
