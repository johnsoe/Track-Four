extends CharacterBody2D
class_name PlayerBall

@export var track_id: int
@export var vert_speed: int
@export var x_speed: int
@export var sprite_override: CompressedTexture2D

@onready var sprite = $Sprite2D

func _ready():
	Events.on_track_clicked.connect(handle_track_click)
	sprite.texture = sprite_override


func _process(delta):
	velocity = Vector2(x_speed, -1 * vert_speed)
	move_and_slide()


func handle_track_click(track: int):
	if (track != track_id):
		return 
	
	x_speed *= -1
