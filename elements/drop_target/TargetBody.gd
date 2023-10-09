extends RigidBody3D

signal BehaviorActivated(active)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(_delta):
	if rotation.x < deg_to_rad(-0.08):
		BehaviorActivated.emit(true)
		print("drop hit")
		
#func _integrate_forces(state):
#	if (state.transform.basis.get_euler() * global_transform.basis.inverse()).x < -0.5:
#		print("drop hit")
