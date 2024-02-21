extends Control

@onready var reset_button = %ResetButton
@onready var high_score_text = %HighScore

func _ready():
	reset_button.pressed.connect(reset_game)


func reset_game():
	get_tree().reload_current_scene()
	get_tree().paused = false


func set_high_score(score: int):
	print(score)
	high_score_text.text = str("High Score: ", score)
