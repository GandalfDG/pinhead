extends RigidBody3D

signal BehaviorActivated(active)
signal trigger_score

@onready var joint: Generic6DOFJoint3D = $"../TiltAndSlideJoint"
#@onready var reset_solenoid = $ResetSolenoid

var dropped: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
#	joint.set_param_y(Generic6DOFJoint3D.PARAM_LINEAR_LIMIT_UPPER, 0)
	pass

func _unhandled_input(event):
	if event.is_action_pressed("debug_reset"):
		reset()

func reset():
	pass
#	joint.set_param_y(Generic6DOFJoint3D.PARAM_LINEAR_LIMIT_UPPER, 0)

func _physics_process(_delta):
	if rotation.x < deg_to_rad(-0.08):
		pass
		# drop hit
#		joint.set_param_y(Generic6DOFJoint3D.PARAM_LINEAR_LIMIT_UPPER, 1.51)
	
	if not dropped and position.y < -0.5:
		dropped =  true
		trigger_score.emit()
		
	if  dropped and position.y > -0.5:
		dropped = false

	
