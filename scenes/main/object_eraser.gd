extends Node2D


@onready var area: Area2D = $Area2D


func _ready():
	area.area_entered.connect(on_area_entered)


func on_area_entered(other: Area2D):
	other.get_parent().queue_free()
