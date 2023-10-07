extends RigidBody3D

signal PhysicsProcessEntered(delta)
signal BehaviorActivated(active)

var resting_position: Vector3
var resting_rotation: Vector3
# Called when the node enters the scene tree for the first time.
func _ready():
	resting_position = global_position
	pass

func _physics_process(delta):
	emit_signal("PhysicsProcessEntered", delta)

func _on_pop_trigger_body_entered(body):
	emit_signal("BehaviorActivated", true)

