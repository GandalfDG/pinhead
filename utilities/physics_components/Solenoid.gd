extends ActivatedPhysicsBehavior


@export var solenoid_force: float = 10
@export var force_type: PhysicsTypes.ForceType = PhysicsTypes.ForceType.LINEAR

var force_vector: Vector3

func _ready():
	super._ready()
	force_vector = Vector3.BACK * global_transform.basis
	

func _physics_process(delta):
	if activated:
		if force_type == PhysicsTypes.ForceType.LINEAR:
			parent_body.apply_force(solenoid_force * force_vector) if activation_type == ActivationType.TOGGLE else parent_body.apply_impulse(solenoid_force * force_vector)
		else:
			parent_body.apply_torque(solenoid_force * force_vector) if activation_type == ActivationType.TOGGLE else parent_body.apply_torque_impulse(solenoid_force * force_vector)



	_process_physics_behavior(delta)
