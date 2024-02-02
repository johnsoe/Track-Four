extends Node2D

@export var pan_speed: int

# Must be child of a Node2D
func _process(delta):
	var pos_delta = Vector2(0, pan_speed * delta)
	var parent = get_parent() as Node2D
	if parent == null: 
		return
		
	parent.global_position = parent.global_position + pos_delta
