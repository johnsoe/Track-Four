extends Node2D
class_name Obstacle2D

@onready var area = $Area2D
@onready var sprite = $Sprite2D

var is_offset = true
var track = 0

func _ready():
	area.body_entered.connect(player_collision)


func player_collision(other: Node2D):
	Events.emit_game_over(track)
	

func flip():
	sprite.flip_v = true


func width():
	return sprite.texture.get_width() * 2
