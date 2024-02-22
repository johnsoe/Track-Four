extends Control

signal countdown_complete

@onready var countdown_label = $PanelContainer/CountdownLabel
@onready var countdown = $Timer

@export var countdown_start: int

func _ready():
	countdown_label.text = str(countdown_start)
	countdown.timeout.connect(on_countdown)


func on_countdown():
	countdown_start -= 1
	if countdown_start == 0:
		countdown_complete.emit()
		self.queue_free()
	else:
		countdown_label.text = str(countdown_start)
