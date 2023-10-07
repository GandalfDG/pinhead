@tool

extends PhysicsBehavior
class_name LocalAxisLock

@export var lock_translation_x: bool = false
@export var lock_translation_y: bool = false
@export var lock_translation_z: bool = false
@export var lock_rotation_x: bool = false
@export var lock_rotation_y: bool = false
@export var lock_rotation_z: bool = false

var rest_position: Vector3
var rest_rotation: Vector3

func _ready():
	super._ready()
	rest_position = parent_node.position
	rest_rotation = parent_node.rotation
	
	
func _process_physics_behavior(_delta: float):
	lock_axes()
	
func _integrate_forces_behavior(_state: PhysicsDirectBodyState3D):
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
