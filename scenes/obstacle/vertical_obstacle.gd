extends Obstacle2D

@export var relative_speed_delta: float

@onready var timer = $Timer
@onready var velocity_component = $VelocityComponent

var travel_direction: int
var init_speed: float

func _ready():
	super()
	timer.timeout.connect(on_timer_timeout)
	is_offset = false
	init_speed = velocity_component.pan_speed
	travel_direction = -1 if randi_range(0, 1) == 0 else 1


func on_timer_timeout():
	travel_direction *= -1
	velocity_component.pan_speed = init_speed + (relative_speed_delta * travel_direction)
