extends RigidBody2D

@export var player: bool = 0

@onready var movement_manager: ThrusterMovementManagerTemp = $thrusterMovementManager

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	print("Inertia is:")
	print(1 / PhysicsServer2D.body_get_direct_state(self.get_rid()).inverse_inertia)
	
	if !player:
		movement_manager.move_front()
		movement_manager.move_back()
		movement_manager.move_left()
		movement_manager.move_right()
		return
		
	if Input.is_action_pressed("move_front"):
		movement_manager.move_front()
		
	if Input.is_action_pressed("move_back"):
		movement_manager.move_back()
	
	if Input.is_action_pressed("move_left"):
		movement_manager.move_left()
	
	if Input.is_action_pressed("move_right"):
		movement_manager.move_right()
	
	if Input.is_action_pressed("rotate_left"):
		movement_manager.rotate_left()
	
	if Input.is_action_pressed("rotate_right"):
		movement_manager.rotate_right()

func _physics_process(delta):
	movement_manager.calculate_forces(delta)
	#apply_central_force(Vector2(randf_range(-300000000, 300000000), randf_range(-300000000, 300000000)))
	#apply_torque(randf_range(-300000000, 300000000))
	apply_central_force(movement_manager.get_total_force())
	apply_torque(movement_manager.get_total_torque())
