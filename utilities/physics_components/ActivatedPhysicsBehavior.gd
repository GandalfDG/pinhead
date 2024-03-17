
extends PhysicsBehavior
class_name ActivatedPhysicsBehavior

enum ActivationType {IMPULSE, TOGGLE}
@export var activation_type: ActivationType = ActivationType.IMPULSE


var activated: bool = false

func activate(active: bool):
	activated = active
