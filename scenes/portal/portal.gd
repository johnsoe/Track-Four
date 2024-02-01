extends Node2D
class_name Portal

signal on_player_collide(swap: Vector2)

@export var portal_sprites: Array[CompressedTexture2D]
@onready var sprite = $Sprite2D
@onready var area = $Area2D

var swap: Vector2

func _ready():
	area.body_entered.connect(on_body_entered)


func set_swap(s: Vector2):
	swap = s
	sprite.texture = portal_sprites[s.y]


func on_body_entered(other: Node2D):
	if swap == null:
		return
	on_player_collide.emit(swap)
	queue_free()
