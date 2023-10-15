@tool

extends ActivatedPhysicsBehavior
class_name SolenoidSpring

enum ForceType {LINEAR, ROTATIONAL} 

@export var force_type: ForceType = ForceType.LINEAR
@export var reverse_force: bool = false

@export var solenoid_force: float = 1:
	set(value):
		solenoid_force = value
@export var spring_stiffness: float = 500
@export var resting_spring_extension: float = 10

var force_vector: Vector3 = Vector3()

func _ready():
	super._ready()
	var force_sign = -1 if reverse_force else 1
	force_vector = force_sign * Vector3(0,1,0) * global_transform.basis
		

# apply impulse in positive Z direction of our Node3D
func _physics_process(_delta):
	# spring force is a function of the stiffness and the distance from the rest position

	if force_type == ForceType.LINEAR:
		var spring_displacement = (parent_body.position + (resting_spring_extension * force_vector) - parent_rest_transform.origin) * transform.basis
		var spring_force = spring_stiffness * spring_displacement
		parent_body.apply_force(spring_force)
		if activated:
			if activation_type == ActivationType.IMPULSE:
				parent_body.apply_impulse(solenoid_force * force_vector)
			else: 
				parent_body.apply_force(solenoid_force * force_vector)
	else:
		var resting_angle: Vector3 = Vector3.RIGHT * parent_rest_transform.basis
		var current_angle: Vector3 = Vector3.RIGHT * parent_body.global_transform.basis
		var spring_displacement = current_angle.angle_to(resting_angle)
#		print(spring_displacement)
		var spring_force = -force_vector * spring_stiffness * spring_displacement
		parent_body.apply_torque(spring_force)
		if activated:
			if activation_type == ActivationType.IMPULSE:
				parent_body.apply_torque_impulse(solenoid_force * force_vector)
			else:
				var force = solenoid_force * force_vector
				parent_body.apply_torque(force)

		
	super._process_physics_behavior(_delta)
