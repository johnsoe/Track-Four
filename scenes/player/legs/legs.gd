extends Node2D

@onready var left_leg = $Visuals/LeftLeg
@onready var right_leg = $Visuals/RightLeg
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var distance_from_center: float
@export var is_init_clockwise: bool


func _ready():
	left_leg.position.x = distance_from_center * -1
	right_leg.position.x = distance_from_center
	
	if is_init_clockwise:
		animation_player.play("walk")
	else:
		animation_player.play_backwards("walk")


func seek_to_position(position_percent: float):
	var anim_length = animation_player.get_animation("walk").length
	animation_player.seek(anim_length * position_percent)
