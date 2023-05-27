extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(0)#I'm good
	var smallify: float = 1
	smallify -= randf_range(0, 0.5)
	
	$Sprite2D.apply_scale(Vector2(smallify, smallify))
	$CollisionShape2D.apply_scale(Vector2(smallify, smallify))
	mass *= smallify
	
	var force_x: int = randi_range(-20, 20)
	var force_y: int = randi_range(-20, 20)
	
	apply_impulse(Vector2(force_x, force_y))
	
	apply_torque(randf_range(-200, 200))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
