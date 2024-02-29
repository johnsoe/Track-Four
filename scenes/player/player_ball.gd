extends CharacterBody2D
class_name PlayerBall

@export var track_id: int
@export var x_speed: int
@export var sprite_override: CompressedTexture2D

@onready var sprite = $Sprite2D
@onready var top_legs = $LegSets/LegsTop
@onready var mid_legs = $LegSets/LegsMid
@onready var bot_legs = $LegSets/LegsBot

func _ready():
	Events.on_track_clicked.connect(handle_track_click)
	sprite.texture = sprite_override
	
	var anim_start_percent = randf()
	top_legs.seek_to_position(anim_start_percent)
	mid_legs.seek_to_position(anim_start_percent)
	bot_legs.seek_to_position(anim_start_percent)


func _process(delta):
	velocity = Vector2(x_speed, 0)
	move_and_slide()


func handle_track_click(track: int):
	if (track != track_id):
		return 
	
	x_speed *= -1
