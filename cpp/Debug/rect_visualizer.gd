extends PhysicsEntity2D

@onready var display_line: Line2D = $Line2RectDisplay

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var collision_rect: Rect2 = get_bounding_rect()
	#print("OurPosition: ")
	#print(global_position)
	#print("Position: ")
	#print(collision_rect.position)
	collision_rect.position -= global_position
	#print("Size: ")
	#print(collision_rect.size)
	display_line.global_rotation = 0;
	display_line.global_position = global_position;
	display_line.clear_points()
	display_line.add_point(collision_rect.position)
	display_line.add_point(Vector2(collision_rect.position.x, collision_rect.end.y))
	display_line.add_point(collision_rect.end)
	display_line.add_point(Vector2(collision_rect.end.x, collision_rect.position.y))
	display_line.add_point(collision_rect.position)
