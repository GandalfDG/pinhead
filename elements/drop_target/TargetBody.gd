extends RigidBody3D

signal BehaviorActivated(active)

@onready var joint: JoltGeneric6DOFJoint3D = $"../TiltAndSlideJoint"
#@onready var reset_solenoid = $ResetSolenoid

var dropped: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	joint.set_param_y(JoltGeneric6DOFJoint3D.PARAM_LINEAR_LIMIT_UPPER, 0)

func _unhandled_input(event):
	if event.is_action_pressed("debug_reset"):
		reset()

func reset():
	joint.set_param_y(JoltGeneric6DOFJoint3D.PARAM_LINEAR_LIMIT_UPPER, 0)

func _physics_process(_delta):
	if rotation.x < deg_to_rad(-0.08):
		# drop hit
		joint.set_param_y(JoltGeneric6DOFJoint3D.PARAM_LINEAR_LIMIT_UPPER, 1.51)
	
	if not dropped and position.y < -0.5:
		dropped =  true
		
	if  dropped and position.y > -0.5:
		dropped = false

	
