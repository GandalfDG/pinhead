extends RigidBody3D

var rest_position: Vector3
var flipping: bool = false

@onready var flipper_node = $".."

# Called when the node enters the scene tree for the first time.
func _ready():
	rest_position = global_position
#	freeze =  true
	constant_torque = Vector3(0,-flipper_node.return_torque,0) * global_transform.basis

func _on_flipper_enable():
#	freeze = false
	constant_torque = Vector3(0,-flipper_node.return_torque,0) * global_transform.basis
	
func _on_flipper_flipping(pressed):
	flipping = pressed
	
func _physics_process(delta):
	if flipping:
		apply_torque(Vector3(0,flipper_node.flip_torque,0) * global_transform.basis)
	
func _integrate_forces(state):
	rotation.x = 0
	rotation.z = 0
	
	global_position = rest_position
	
	state.integrate_forces()

