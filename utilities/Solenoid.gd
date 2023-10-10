extends ActivatedPhysicsBehavior

@export var force_type: ForceType = ForceType.LINEAR
@export var reverse_force: bool = false

@export var solenoid_force: float = 1:
	set(value):
		solenoid_force = value

func _physics_process(delta):

	super._process_physics_behavior(delta)
