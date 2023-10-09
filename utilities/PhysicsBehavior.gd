@tool
extends Node3D

class_name PhysicsBehavior

var parent_node: Node
var parent_body: RigidBody3D
var connected_signals: Array[StringName]

var parent_rest_position: Vector3
var parent_rest_rotation: Vector3
@onready var parent_rest_transform: Transform3D = parent_node.global_transform
var parent_rest_quaternion: Quaternion

func _enter_tree():
	parent_node = $'..'

	parent_node.script_changed.connect(update_configuration_warnings, ConnectFlags.CONNECT_DEFERRED)
	if parent_node.has_signal("PhysicsProcessEntered"):
		connected_signals.append("PhysicsProcessEntered")

	if parent_node.has_signal("IntegrateForcesEntered"):
		connected_signals.append("IntegrateForcesEntered")

	update_configuration_warnings()

func _exit_tree():
	parent_node.script_changed.disconnect(update_configuration_warnings)

# ensure the parent is derived from RigidBody3D
func _get_configuration_warnings():
	var warnings: Array = []
	if not parent_node is RigidBody3D:
		warnings.append("Parent node must be derived from RigidBody3D")
	
	if not "PhysicsProcessEntered" in connected_signals or not "IntegrateForcesEntered" in connected_signals:
		warnings.append("Parent must emit PhysicsProcessEntered and/or IntegrateForcesEntered signals")

	return warnings

func _ready():
	if "PhysicsProcessEntered" in connected_signals:
		parent_node.PhysicsProcessEntered.connect(_process_physics_behavior)
	if "IntegrateForcesEntered" in connected_signals:
		parent_node.IntegrateForcesEntered.connect(_integrate_forces_behavior)

	parent_body = parent_node

	parent_rest_position = parent_body.position
	parent_rest_rotation = parent_body.rotation
	parent_rest_quaternion = parent_body.quaternion

func _process_physics_behavior(_delta: float):
	pass

func _integrate_forces_behavior(_state: PhysicsDirectBodyState3D):
	pass

