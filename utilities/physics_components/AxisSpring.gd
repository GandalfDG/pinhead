@tool
extends PhysicsBehavior


@export var force_type: PhysicsTypes.ForceType = PhysicsTypes.ForceType.LINEAR

@export var spring_stiffness: float = 500
@export var spring_preload: float = 10

var force_vector: Vector3 = Vector3.BACK

func _physics_process(_delta):
	var spring_force_vector = force_vector
	if force_type == PhysicsTypes.ForceType.LINEAR:
		var spring_displacement = abs((parent_body.global_transform.origin - parent_rest_transform.origin).length())
		spring_force_vector = spring_stiffness * (spring_displacement + spring_preload) * force_vector
		var force = spring_force_vector * parent_body.global_transform.basis
		parent_body.apply_force(spring_force_vector * parent_body.global_transform.basis)

	elif force_type == PhysicsTypes.ForceType.ROTATIONAL:
		var resting_vector = parent_rest_transform.basis * Vector3.UP
		var current_vector = parent_body.global_transform.basis * Vector3.UP
		var spring_displacement = current_vector.angle_to(resting_vector)
		spring_force_vector = spring_stiffness * (spring_displacement + spring_preload) * force_vector * global_transform.basis
		parent_body.apply_torque(spring_force_vector * parent_body.global_transform.basis)

