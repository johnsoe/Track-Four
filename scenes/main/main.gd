extends Node

@onready var track_manager: TrackManager = $TrackManager
@onready var death_screen = $DeathScreen 
@onready var distance_manager: DistanceManager = $DistanceManager

@export var ball_scene: PackedScene
@export var ball_sprites: Array[CompressedTexture2D]

var current_score = 0
var high_score = 0
var save_path = "user://score.save"

func _ready():
	load_score()
	Events.on_game_over.connect(handle_game_over)
	distance_manager.on_distance_updated.connect(handle_distance_update)
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
	

func handle_distance_update(distance: int):
	current_score = distance
