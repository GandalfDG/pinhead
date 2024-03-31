extends PhysicsBehavior

@export var spring_stiffness: float = 500
@export var spring_preload: float = 1

func _ready():
	force_vector *= global_transform.basis
	print(transform.basis)
	print(force_vector)

func _physics_process(_delta):

	if force_type == PhysicsTypes.ForceType.LINEAR:
		var spring_displacement = (physics_body.transform.origin - body_rest_transform.origin).length()
		var spring_force_vector = spring_stiffness * (spring_displacement + spring_preload) * force_vector
		physics_body.apply_force(spring_force_vector * physics_body.global_transform.basis)

	# elif force_type == PhysicsTypes.ForceType.ROTATIONAL:
	# 	var resting_vector = parent_rest_transform.basis * Vector3.UP
	# 	var current_vector = parent_node.global_transform.basis * Vector3.UP
	# 	var spring_displacement = current_vector.angle_to(resting_vector)
	# 	var spring_force_vector = spring_stiffness * (spring_displacement + spring_preload) * force_vector
	# 	parent_node.apply_torque(spring_force_vector * parent_node.global_transform.basis)
