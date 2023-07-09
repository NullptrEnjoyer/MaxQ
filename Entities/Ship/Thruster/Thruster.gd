extends Component

class_name ThrusterTemp

@export_group("Thruster Properties")
@export var power: int = 100
##0 to 2
@export var number_of_sprites: int = 2
@export_color_no_alpha var color = Color(0.5,1,1,1)
@export var animate: bool = 0;

@export_group("Movement Manager Settings")
@export var move_front: bool = 0
@export var move_back: bool = 0
@export var move_left: bool = 0
@export var move_right: bool = 0
@export var rotate_left: bool = 0
@export var rotate_right: bool = 0
#Turn off if I ever make vectored engines
@export var precompute: bool = 1

@onready var sprite: AnimatedSprite2D = $Layer0

var main_body: RigidBody2D

var num_of_rays: int = 0
var ray_arr: Array = Array()

var offset: Vector2 = Vector2()

var precomp_torque: float = 0
var precomp_force: Vector2 = Vector2()

func setup_sprite_child(parent:AnimatedSprite2D, clone:AnimatedSprite2D, position_offset:int) -> void:
		parent.add_child(clone)
		
		clone.modulate.r *= 0.95
		clone.modulate.g *= 0.95
		clone.modulate.b *= 0.95
		
		clone.scale.x *= 0.8
		clone.scale.y *= 0.8
		clone.position.y += position_offset
		clone.write_memory()

func set_state(state:bool) -> void:
	if state:
		if sprite.visible:
			return
		sprite.visible = 1
		set_process(1)
	else:
		if !sprite.visible:
			return
		sprite.scale.x = 1
		sprite.visible = 0
		set_process(0)

func set_main_body(node: RigidBody2D) -> void:
	main_body = node
	add_raycast_exception(node)
	
	precomp_force.x = sin(rotation) * power
	precomp_force.y = -cos(rotation) * power
	offset.x = position.x - node.center_of_mass.x
	offset.y = position.y - node.center_of_mass.y
	
	precomp_torque = -(offset.x * precomp_force.y + offset.y * precomp_force.x)

func add_raycast_exception(node: CollisionObject2D) -> void:
	for child_node in get_children():
		if  child_node.get_class() == "RayCast2D":
			child_node.add_exception(node)

func handle_raycast_check(delta) -> void:
	var scale_sprite_x: float = 1
	
	var point: Vector2
	var dist: float
	var mult: float
	var what: CollisionObject2D
	var ray_force: Vector2
	
	for node in ray_arr:
		if ((node.is_colliding())):
			point = node.get_collision_point()
			dist = node.global_position.distance_to(point)
			mult = 1 - dist / node.max_dist
			what = node.get_collider()
			
			scale_sprite_x += mult / num_of_rays# / 3
			
			ray_force = precomp_force.rotated(main_body.global_rotation)
			
			#apply force to the main body
			ray_force.x /= num_of_rays
			ray_force.x *= mult * delta
			ray_force.y /= num_of_rays
			ray_force.y *= mult * delta
			
			offset.x = point.x - global_position.x
			offset.y = point.y - global_position.y
			
			main_body.apply_force(ray_force, offset)
			
			ray_force.x *= -1
			ray_force.y *= -1
			
			offset.x = point.x - what.global_position.x
			offset.y = point.y - what.global_position.y
			
			what.apply_force(ray_force, offset)
		
	sprite.scale.x = scale_sprite_x

func get_torque() -> float:
	return precomp_torque

func get_force() -> Vector2:
	return precomp_force

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(0)
	set_physics_process(0)
	
	#$AudioStreamPlayer2D.volume_db += 15 * log(power) - 50
	
	power *= 20000000
	
	sprite.modulate = color
	
	if (number_of_sprites > 0):
		var bro1: AnimatedSprite2D = sprite.duplicate()
		setup_sprite_child(sprite, bro1, -10)
		bro1.set_frame_and_progress(1, 0)
		if (number_of_sprites > 1):
			var bro2: AnimatedSprite2D = bro1.duplicate()
			setup_sprite_child(bro1, bro2, -8)
			bro2.set_frame_and_progress(2, 0)
	
	sprite.visible = 0
	
	for node in get_children():
		if (node.get_class() == "RayCast2D"):
			num_of_rays += 1
			ray_arr.push_back(node)
