@tool

extends PhysicsBehavior
class_name ActivatedPhysicsBehavior

enum ActivationType {IMPULSE, TOGGLE}
@export var activation_type: ActivationType = ActivationType.IMPULSE

var activated: bool = false

func _process_physics_behavior(_delta):
	if activated and activation_type == ActivationType.IMPULSE:
		activated = false

func _activate_physics_behavior(active: bool):
	activated = active
