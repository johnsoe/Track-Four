extends Node2D


@onready var area: Area2D = $Area2D


func _ready():
	area.area_entered.connect(on_area_entered)


func on_area_entered(area: Area2D):
	area.get_parent().queue_free()
