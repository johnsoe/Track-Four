extends Obstacle2D

@export var horizontal_speed: float

@onready var timer = $InitTimer
@onready var active_timer = $ActiveTimer

var travel_direction: int

func _ready():
	super()
	timer.timeout.connect(on_init_timer_timeout)
	active_timer.timeout.connect(on_timer_timeout)
	is_offset = false
	travel_direction = -1 if randi_range(0, 1) == 0 else 1


func _process(delta):
	var pos_delta = Vector2(horizontal_speed * delta * travel_direction, 0)
	global_position = global_position + pos_delta


func on_init_timer_timeout():
	active_timer.start()
	on_timer_timeout()


func on_timer_timeout():
	travel_direction *= -1
