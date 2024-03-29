extends Node

@onready var track_manager: TrackManager = $TrackManager
@onready var death_screen = $DeathScreen 
@onready var distance_manager: DistanceManager = $DistanceManager
@onready var countdown = $StartCountdown
@onready var distance_label = %DistanceLabel

@export var ball_scene: PackedScene
@export var ball_sprites: Array[CompressedTexture2D]

var current_score = 0 
var high_score = 0
var save_path = "user://score.save"

func _ready():
	load_score()
	Events.on_game_over.connect(handle_game_over)
	Events.on_obstacle_passed.connect(handle_obstacle_passed)
	countdown.countdown_complete.connect(on_countdown_complete)
	get_tree().root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP_HEIGHT
	get_tree().root.content_scale_mode = Window.CONTENT_SCALE_MODE_VIEWPORT
	
	for i in range(0, 2):
		var ball_spawn_pos = track_manager.get_track_spawn_position(i, 1, TrackManager.LOCATION.BOTTOM)
		var ball_inst = ball_scene.instantiate() as PlayerBall
		ball_inst.track_id = i
		ball_inst.sprite_override = ball_sprites[i]
		add_child(ball_inst)
		ball_inst.global_position = ball_spawn_pos
		Events.emit_ball_spawn(ball_inst, i)
	
	get_tree().paused = true


func handle_game_over(track: int):
	save_score()
	get_tree().paused = true
	death_screen.visible = true
	death_screen.set_track_collision(track)
	death_screen.set_scores(high_score, current_score)


func save_score():
	if current_score > high_score:
		high_score = current_score
		var file = FileAccess.open(save_path, FileAccess.WRITE)
		file.store_var(current_score)


func load_score():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		high_score = file.get_var()
	else:
		high_score = 0
	

func handle_obstacle_passed():
	current_score += 1
	distance_label.text = str(current_score)


func on_countdown_complete():
	get_tree().paused = false
