extends ActivatedPhysicsBehavior


@export var solenoid_force: float = 10
@export var force_type: PhysicsTypes.ForceType = PhysicsTypes.ForceType.LINEAR

var force_vector: Vector3

func _ready():
	force_vector = Vector3.UP * global_transform.basis

func _physics_process(delta):
	if activated:
		if force_type == PhysicsTypes.ForceType.LINEAR:
			physics_body.apply_force(solenoid_force * force_vector) if activation_type == ActivationType.TOGGLE else physics_body.apply_impulse(solenoid_force * force_vector)
		else:
			physics_body.apply_torque(solenoid_force * force_vector) if activation_type == ActivationType.TOGGLE else physics_body.apply_torque_impulse(solenoid_force * force_vector)
