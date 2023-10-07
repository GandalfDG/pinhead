@tool
extends ActivatedPhysicsBehavior

enum ForceType {LINEAR, ROTATIONAL} 

@export var force_type: ForceType = ForceType.LINEAR

@export var solenoid_force: float = 1
@export var spring_stiffness: float = 500
@export var resting_spring_extension: float = 10:
	set(value):
		spring_extension_vector = Vector3(0,0,value) * transform.basis
		resting_spring_extension = value
		

var spring_extension_vector

func _ready():
	super._ready()
	activation_type = ActivationType.IMPULSE
	

# apply impulse in positive Z direction of our Node3D
func _process_physics_behavior(_delta):
	# spring force is a function of the stiffness and the distance from the rest position
	var spring_force = spring_stiffness * (parent_body.position * transform.basis - parent_rest_position * transform.basis + spring_extension_vector)
	if force_type == ForceType.LINEAR:
		parent_body.apply_force(spring_force)
		if activated:
			parent_body.apply_impulse(-Vector3(0,0,solenoid_force) * transform.basis)
	else:
		parent_body.apply_torque(spring_force)
		if activated:
			parent_body.apply_torque_impulse(-Vector3(0,0,solenoid_force) * transform.basis)
		
	super._process_physics_behavior(_delta)
