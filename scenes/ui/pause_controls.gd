extends Control

@onready var resume_button = %ResumeButton


func _ready():
	resume_button.pressed.connect(on_resume_pressed)


func _notification(what):
	print(what)
	if what == MainLoop.NOTIFICATION_APPLICATION_FOCUS_OUT:
		get_tree().paused = true
		self.visible = true


func on_resume_pressed():
	get_tree().paused = false
	self.visible = false
