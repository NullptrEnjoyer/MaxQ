extends ThrusterMovementController


# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(true)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	if Input.is_action_pressed("move_front"):
		move_fullspeed()
		move_front()
		
	if Input.is_action_pressed("move_back"):
		move_back()
	
	if Input.is_action_pressed("move_left"):
		move_left()
	
	if Input.is_action_pressed("move_right"):
		move_right()
	
	if Input.is_action_pressed("rotate_left"):
		rotate_left()
	
	if Input.is_action_pressed("rotate_right"):
		rotate_right()
