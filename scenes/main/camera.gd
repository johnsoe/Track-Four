extends Node
class_name CameraManager

@export var pan_speed: float
@onready var camera = $Camera2D


func _ready():
	camera.make_current()


func _process(delta):
	var pos_delta = Vector2(0, pan_speed * delta)
	camera.global_position = camera.global_position - pos_delta


func calculate_camera_offset():
	var camera_viewport_pos = camera.get_viewport().get_visible_rect().position
	var camera_pos = camera.global_position
	return camera_pos - camera_viewport_pos


func get_camera_rect():
	return camera.get_viewport().get_visible_rect()


func camera_position():
	return camera.global_position
