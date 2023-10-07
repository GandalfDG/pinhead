@tool
extends Node

class_name PhysicsBehavior

var parent_node: Node
var parent_body: PhysicsBody3D
var connected_signals: Array[StringName]

func _enter_tree():
	print('enter')
	parent_node = $'..'

	parent_node.script_changed.connect(update_configuration_warnings)
	if parent_node.has_signal("PhysicsProcessEntered"):
		connected_signals.append("PhysicsProcessEntered")

	if parent_node.has_signal("IntegrateForcesEntered"):
		connected_signals.append("IntegrateForcesEntered")

	update_configuration_warnings()

func _exit_tree():
	parent_node.script_changed.disconnect(update_configuration_warnings)

# ensure the parent is derived from PhysicsBody3D
func _get_configuration_warnings():
	var warnings: Array = []
	if not parent_node is PhysicsBody3D:
		warnings.append("Parent node must be derived from PhysicsBody3D")
	
	if not connected_signals:
		warnings.append("Parent must emit PhysicsProcessEntered and/or IntegrateForcesEntered signals")
	
	return warnings

func _ready():
	if "PhysicsProcessEntered" in connected_signals:
		parent_node.PhysicsProcessEntered.connect(_process_physics_behavior)
	if "IntegrateForcesEntered" in connected_signals:
		parent_node.IntegrateForcesEntered.connect(_integrate_forces_behavior)

func _process_physics_behavior(_delta: float):
	pass

func _integrate_forces_behavior(_state: PhysicsDirectBodyState3D):
	pass
