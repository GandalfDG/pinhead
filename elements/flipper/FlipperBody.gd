extends RigidBody3D

signal IntegrateForcesEntered(state)

var rest_position: Vector3
var flipping: bool = false

@onready var flipper_node = $".."

# Called when the node enters the scene tree for the first time.
func _ready():
	rest_position = global_position
#	freeze =  true
	
func _on_flipper_flipping(pressed):
	flipping = pressed
	
func _physics_process(delta):
	apply_torque(Vector3(0,-flipper_node.return_torque,0) * global_transform.basis)
	if flipping:
		apply_torque(Vector3(0,flipper_node.flip_torque,0) * global_transform.basis)
	
func _integrate_forces(state):
	emit_signal("IntegrateForcesEntered", state)
	state.integrate_forces()

