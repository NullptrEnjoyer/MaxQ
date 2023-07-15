extends Thruster

@export_color_no_alpha var color = Color(0.5,1,1,1)
@onready var sprite: Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	
	sprite.modulate = color


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
