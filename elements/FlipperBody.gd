extends RigidBody3D

var rest_position

# Called when the node enters the scene tree for the first time.
func _ready():
	rest_position = global_position
	
func _integrate_forces(state):
	rotation.x = 0
	rotation.z = 0
	
	global_position = rest_position
	
	state.integrate_forces()
