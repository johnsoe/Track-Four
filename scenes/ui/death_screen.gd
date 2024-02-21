extends Control

@onready var reset_button = %ResetButton
@onready var high_score_label = %HighScore
@onready var game_score_label = %GameScore

func _ready():
	reset_button.pressed.connect(reset_game)


func reset_game():
	get_tree().reload_current_scene()
	get_tree().paused = false


func set_scores(high_score: int, game_score: int):
	high_score_label.text = str("High Score: ", high_score)
	game_score_label.text = str("Score: ", game_score)
