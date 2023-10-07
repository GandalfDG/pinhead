extends RigidBody3D

signal BehaviorActivated(active)
signal PhysicsProcessEntered(delta)

var flipping: bool = false
	
func _on_flipper_flipping(pressed):
	BehaviorActivated.emit(pressed)
	
func _physics_process(delta):
	PhysicsProcessEntered.emit(delta)
