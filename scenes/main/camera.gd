extends Node
class_name CameraManager

@onready var camera = $Camera2D

func _ready():
	camera.make_current()
