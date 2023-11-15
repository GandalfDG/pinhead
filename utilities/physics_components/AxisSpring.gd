extends PhysicsBehavior


@export var force_type: PhysicsTypes.ForceType = PhysicsTypes.ForceType.LINEAR

@export var spring_stiffness: float = 500
@export var spring_preload: float = 10

var force_vector: Vector3 = Vector3.UP

func _ready():
	force_vector *= global_transform.basis

func _physics_process(_delta):

	var basis = global_transform.basis
	if force_type == PhysicsTypes.ForceType.LINEAR:
		var spring_displacement = abs((parent_node.global_transform.origin - parent_rest_transform.origin).length())
		var spring_force_vector = spring_stiffness * (spring_displacement + spring_preload) * force_vector
		parent_node.apply_force(spring_force_vector)

	# elif force_type == PhysicsTypes.ForceType.ROTATIONAL:
	# 	var resting_vector = parent_rest_transform.basis * Vector3.UP
	# 	var current_vector = parent_node.global_transform.basis * Vector3.UP
	# 	var spring_displacement = current_vector.angle_to(resting_vector)
	# 	var spring_force_vector = spring_stiffness * (spring_displacement + spring_preload) * force_vector * global_transform.basis
	# 	parent_node.apply_torque(spring_force_vector * parent_node.global_transform.basis)

