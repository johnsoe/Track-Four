extends MarginContainer

@onready var reset_button = $VBoxContainer/Button

func _ready():
	reset_button.pressed.connect(reset_game)
	
func reset_game():
	get_tree().reload_current_scene()
	get_tree().paused = false
