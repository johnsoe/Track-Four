extends Camera2D

@export var pan_speed: float

func _ready():
	make_current()


func _process(delta):
	var pos_delta = Vector2(0, pan_speed * delta)
	global_position = global_position - pos_delta
