@tool
extends PhysicsBehavior

enum ForceType {LINEAR, ROTATIONAL} 

@export var force_type: ForceType = ForceType.LINEAR
@export var reverse_force: bool = false:
	set(value):
		reverse_force = value
		var force_sign = -1 if value else 1
		force_vector = Vector3.FORWARD * force_sign

@export var spring_stiffness: float = 500
@export var spring_preload: float = 10

var force_vector: Vector3 = Vector3.FORWARD

func _physics_process(_delta):
	var spring_force_vector = force_vector
	if force_type == ForceType.LINEAR:
		var spring_displacement = ((parent_body.global_transform.origin - parent_rest_transform.origin) * parent_body.global_transform.basis.inverse() * force_vector).length()
		spring_force_vector = spring_stiffness * (spring_displacement + spring_preload) * force_vector * global_transform.basis
		parent_body.apply_force(spring_force_vector)

	elif force_type == ForceType.ROTATIONAL:
		var spring_displacement = rad_to_deg(parent_body.rotation.z - parent_rest_rotation.z)
		spring_force_vector = spring_stiffness * (spring_displacement + spring_preload) * force_vector
		parent_body.apply_torque(spring_force_vector * parent_body.global_transform.basis)

