extends Node

@onready var track_manager: TrackManager = $TrackManager
@onready var swap_manager: SwapManager = $SwapManager

@export var ball_scene: PackedScene
@export var ball_sprites: Array[CompressedTexture2D]

func _ready():
	#get_tree().root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP_HEIGHT
	get_tree().root.content_scale_mode = Window.CONTENT_SCALE_MODE_VIEWPORT
	
	for i in range(0, 2):
		var ball_spawn_pos = track_manager.get_track_spawn_position(i, 1, TrackManager.LOCATION.BOTTOM)
		var ball_inst = ball_scene.instantiate() as PlayerBall
		ball_inst.track_id = i
		ball_inst.sprite_override = ball_sprites[i]
		add_child(ball_inst)
		ball_inst.global_position = ball_spawn_pos
		Events.emit_ball_spawn(ball_inst, i)
		

func _process(delta):
	pass
