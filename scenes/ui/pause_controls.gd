extends Control

@onready var resume_button = %ResumeButton


func _ready():
	resume_button.pressed.connect(on_resume_pressed)


func _notification(what):
	# Don't do anything if the game is already paused
	if get_tree() == null || get_tree().paused == true:
		return
		
	if what == MainLoop.NOTIFICATION_APPLICATION_FOCUS_OUT \
	or what == NOTIFICATION_WM_WINDOW_FOCUS_OUT \
	or what == NOTIFICATION_APPLICATION_PAUSED:
		get_tree().paused = true
		self.visible = true


func on_resume_pressed():
	get_tree().paused = false
	self.visible = false
