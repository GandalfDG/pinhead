@tool

extends Node
class_name LocalAxisLock

@export var lock_translation_x: bool = false
@export var lock_translation_y: bool = false
@export var lock_translation_z: bool = false
@export var lock_rotation_x: bool = false
@export var lock_rotation_y: bool = false
@export var lock_rotation_z: bool = false

@onready var parent_node: PhysicsBody3D = $'..':
	set(value):
		parent_node = value
		update_configuration_warnings()

var rest_position: Vector3
var rest_rotation: Vector3

# ensure the parent is derived from PhysicsBody3D
func _get_configuration_warnings():
	if not parent_node is PhysicsBody3D:
		return ["parent must be derived from PhysicsBody3D"]

func _ready():
	rest_position = parent_node.position
	rest_rotation = parent_node.rotation
	
func lock_axes():
	parent_node.position = Vector3(
		parent_node.rest_position.x if lock_translation_x else parent_node.position.x,
		parent_node.rest_position.y if lock_translation_y else parent_node.position.y,
		parent_node.rest_position.z if lock_translation_z else parent_node.position.z
	)
	
	parent_node.rotation = Vector3(
		parent_node.rest_rotation.x if lock_rotation_x else parent_node.rotation.x,
		parent_node.rest_rotation.y if lock_rotation_y else parent_node.rotation.y,
		parent_node.rest_rotation.z if lock_rotation_z else parent_node.rotation.z
	)
