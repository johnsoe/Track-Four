extends CharacterBody2D
class_name PlayerBall

@export var track_id: int
@export var x_speed: int
@export var sprite_override: CompressedTexture2D

@onready var trail: GPUParticles2D = $Trail
@onready var sprite = $Sprite2D

func _ready():
	Events.on_track_clicked.connect(handle_track_click)
	sprite.texture = sprite_override
	trail.texture = sprite_override


func _process(delta):
	velocity = Vector2(x_speed, 0)
	move_and_slide()
	#trail.process_material.direction = Vector3(velocity.x, velocity.x, 0)


func handle_track_click(track: int):
	if (track != track_id):
		return 
	
	x_speed *= -1
