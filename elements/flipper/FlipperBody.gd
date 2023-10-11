extends RigidBody3D

signal BehaviorActivated(active)

var flipping: bool = false
	
func _on_flipper_flipping(pressed):
	BehaviorActivated.emit(pressed)
