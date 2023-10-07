@tool

extends Node
class_name LocalAxisLock

@export var lock_translation_x: bool = false
@export var lock_translation_y: bool = false
@export var lock_translation_z: bool = false
@export var lock_rotation_x: bool = false
@export var lock_rotation_y: bool = false
@export var lock_rotation_z: bool = false

var parent_node: Node
var parent_body: PhysicsBody3D
var connected_signals: Array[StringName]

var rest_position: Vector3
var rest_rotation: Vector3

func _enter_tree():
	parent_node = $'..'
	parent_node.script_changed.connect(update_configuration_warnings)
	if parent_node.has_signal("PhysicsProcessEntered"):
		connected_signals.append("PhysicsProcessEntered")
		parent_node.PhysicsProcessEntered.connect(physics_process)
	if parent_node.has_signal("IntegrateForcesEntered"):
		connected_signals.append("IntegrateForcesEntered")
		parent_node.IntegrateForcesEntered.connect(integrate_forces)
	update_configuration_warnings()

# ensure the parent is derived from PhysicsBody3D
func _get_configuration_warnings():
	var warnings: Array = []
	if not parent_node is PhysicsBody3D:
		warnings.append("Parent node must be derived from PhysicsBody3D")
	

	if not connected_signals:
		warnings.append("Parent must emit PhysicsProcessEntered and/or IntegrateForcesEntered signals")
	
	return warnings

func _ready():
	rest_position = parent_node.position
	rest_rotation = parent_node.rotation
	
func physics_process(delta: float):
	lock_axes()
	
func integrate_forces(state: PhysicsDirectBodyState3D):
	lock_axes()
	
func lock_axes():
	parent_node.position = Vector3(
		rest_position.x if lock_translation_x else parent_node.position.x,
		rest_position.y if lock_translation_y else parent_node.position.y,
		rest_position.z if lock_translation_z else parent_node.position.z
	)
	
	parent_node.rotation = Vector3(
		rest_rotation.x if lock_rotation_x else parent_node.rotation.x,
		rest_rotation.y if lock_rotation_y else parent_node.rotation.y,
		rest_rotation.z if lock_rotation_z else parent_node.rotation.z
	)
