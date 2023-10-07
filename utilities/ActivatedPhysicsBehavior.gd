@tool

extends PhysicsBehavior
class_name ActivatedPhysicsBehavior

enum ActivationType {IMPULSE, TOGGLE}
@export var activation_type: ActivationType = ActivationType.IMPULSE

var activated: bool = false

func _enter_tree():
	super._enter_tree()
	if parent_node.has_signal("BehaviorActivated"):
		connected_signals.append("BehaviorActivated")
	update_configuration_warnings()

func _get_configuration_warnings():
	var warnings = super._get_configuration_warnings()

	if "BehaviorActivated" not in connected_signals:
		warnings.append("Parent must emit BehaviorActivated when behavior should be triggered")

	return warnings

func _ready():
	super._ready()

	if "BehaviorActivated" in connected_signals:
		parent_node.BehaviorActivated.connect(_activate_physics_behavior)

func _process_physics_behavior(_delta):
	if activated and activation_type == ActivationType.IMPULSE:
		activated = false

func _activate_physics_behavior( active: bool):
	activated = active
