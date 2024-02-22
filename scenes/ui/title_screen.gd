extends Control

@onready var play_button = %PlayButton
@onready var settings_button = %SettingsButton


func _ready():
	play_button.pressed.connect(on_play_pressed)
	settings_button.pressed.connect(on_settings_pressed)


func on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func on_settings_pressed():
	print("Settings Pressed")
