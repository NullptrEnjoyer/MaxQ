extends AnimatedSprite2D

var orig_x:float
var orig_y:float

func write_memory():
	orig_x = position.x
	orig_y = position.y
