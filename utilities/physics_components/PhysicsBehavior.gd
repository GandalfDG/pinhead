@tool
extends Node3D

class_name PhysicsBehavior

var parent_node: Node
var parent_body: RigidBody3D
var connected_signals: Array[StringName]

@onready var parent_rest_transform: Transform3D = parent_node.global_transform

func _enter_tree():
	parent_node = $'..'

	parent_node.script_changed.connect(update_configuration_warnings, ConnectFlags.CONNECT_DEFERRED)


func _exit_tree():
	parent_node.script_changed.disconnect(update_configuration_warnings)

# ensure the parent is derived from RigidBody3D
func _get_configuration_warnings():
	var warnings: Array = []
	if not parent_node is RigidBody3D:
		warnings.append("Parent node must be derived from RigidBody3D")

	return warnings

func _ready():
	parent_body = parent_node

func _process_physics_behavior(_delta: float):
	pass

func _integrate_forces_behavior(_state: PhysicsDirectBodyState3D):
	pass

