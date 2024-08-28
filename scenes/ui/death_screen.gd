extends Control

@export var colors: UIColors

@onready var high_score_label = %HighScore
@onready var game_score_label = %GameScore
@onready var reset_button = %ResetButton
@onready var rate_button = %RateButton
@onready var share_button = %ShareButton
@onready var quit_button = %QuitButton
@onready var panel = $Panel


func _ready():
	reset_button.pressed.connect(reset_game)


func reset_game():
	get_tree().paused = false
	get_tree().reload_current_scene()


func set_scores(high_score: int, game_score: int):
	high_score_label.text = str("High Score: ", high_score)
	game_score_label.text = str("Score: ", game_score)


# This is so ugly, need designer to make work
func set_track_collision(_track: int):
	pass
