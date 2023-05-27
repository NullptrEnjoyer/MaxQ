extends Subsystem
class_name ThrusterMovementManager

@export_group("Manager Properties")
##How far up the parent tree the actual physics object is
@export var depth: int = 1

var main_arr: Array = Array()
var status_arr: Array = Array()

var move_front_arr: Array = Array()
var move_back_arr: Array = Array()
var move_left_arr: Array = Array()
var move_right_arr: Array = Array()
var rotate_left_arr: Array = Array()
var rotate_right_arr: Array = Array()

var main_body: RigidBody2D

var total_force_vec: Vector2 = Vector2()
var total_torque: float = 0

var pass_arr: Array = Array()

#var frame_skip: int = 2
#var spread_load: int = FrameSkip.get_frame_ticket("Thruster", frame_skip)

var index: int = 0 # Used once in _ready() and then the rest of the time in _physics_process()

var precalc_force_arr: Array = Array()
var precalc_torque_arr: Array = Array()

func move_front():
	for i in move_front_arr:
		status_arr[i] = true

func move_back():
	for i in move_back_arr:
		status_arr[i] = true

func move_left():
	for i in move_left_arr:
		status_arr[i] = true

func move_right():
	for i in move_right_arr:
		status_arr[i] = true

func rotate_left():
	for i in rotate_left_arr:
		status_arr[i] = true

func rotate_right():
	for i in rotate_right_arr:
		status_arr[i] = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass_arr.resize(3)
	
	depth = depth - 1;
	
	main_body = get_parent()
	for i in depth:
		main_body = main_body.get_parent()
	
	#All the small arrays are the index of the thruster in the main array
	#The status arr is an arr of bools which indicate what state the thruster should be in
	#We go through these in _process() and determine which ones are on and which ones are off
	for thruster in get_children():
		thruster.set_main_body(main_body)
		precalc_force_arr.append(thruster.get_force())
		precalc_torque_arr.append(thruster.get_torque())
		
		main_arr.append(thruster)
		status_arr.append(false)
		if thruster.move_front:
			move_front_arr.append(index)
		if thruster.move_back:
			move_back_arr.append(index)
		if thruster.move_left:
			move_left_arr.append(index)
		if thruster.move_right:
			move_right_arr.append(index)
		if thruster.rotate_left:
			rotate_left_arr.append(index)
		if thruster.rotate_right:
			rotate_right_arr.append(index)
		index += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
#	if ((Engine.get_physics_frames() + spread_load) % frame_skip) != 0:
#		return
	var pindex: int = 0
	for true_false in status_arr:
		if true_false != main_arr[pindex].is_processing():
			main_arr[pindex].set_state(true_false)
		status_arr[pindex] = false;
		pindex += 1

func calculate_forces(delta) -> void:
	total_force_vec.x = 0
	total_force_vec.y = 0
	total_torque = 0
	index = 0

	for thruster in main_arr:
		if thruster.is_processing():
			total_force_vec += precalc_force_arr[index]
			total_torque += precalc_torque_arr[index]
			thruster.handle_raycast_check(delta)
		index += 1

	total_force_vec = total_force_vec.rotated(global_rotation)

	total_force_vec.x *= delta
	total_force_vec.y *= delta
	total_torque *= delta

func get_total_force() -> Vector2:
	return total_force_vec

func get_total_torque() -> float:
	return total_torque

#Far more efficient to apply everything after calculating it here
#func _physics_process(delta) -> void:
#	if ((Engine.get_physics_frames() + spread_load) % frame_skip) != 0:
#		return
#
#	calculate_forces(delta)
#	main_body.apply_central_force(total_force_vec)
#	main_body.apply_torque(total_torque * delta)










