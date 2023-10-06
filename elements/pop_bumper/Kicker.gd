extends RigidBody3D

var resting_position: Vector3
var resting_rotation: Vector3
# Called when the node enters the scene tree for the first time.
func _ready():
	resting_position = global_position
	add_constant_force(Vector3(0,3,0)*global_transform.basis)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _integrate_forces(state):
	rotation = Vector3()
	position.x = 0
	position.z = 0
	
	state.integrate_forces()


func _on_pop_trigger_body_entered(body):
	apply_impulse(Vector3(0,-.3,0)*global_transform.basis)
