extends Obstacle2D

@onready var second_sprite = $Sprite2D2

func flip():
	super()
	second_sprite.flip_v = true


func width():
	return second_sprite.texture.get_width() * 4 - second_sprite.position.x
