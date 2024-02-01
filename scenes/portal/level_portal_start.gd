extends Node2D

signal on_player_collide()


@onready var area = $Area2D


func _ready():
	area.body_entered.connect(on_body_entered)


func on_body_entered(other: Node2D):
	on_player_collide.emit()
	other.queue_free()
	queue_free()
