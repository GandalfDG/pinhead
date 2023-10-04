extends RigidBody3D

@export_enum("left", "right") var flipper_side: String = "left"
@export var flip_duration: float = .035
@export var flip_angle: float = 25.0

var flipper_action: String = "left_flipper"
var resting_transform: Transform3D
var resting_rotation: Vector3

var flipping: bool = false
		
func flip():
	flipping = true
	
func retract():
	flipping = false

# Called when the node enters the scene tree for the first time.
func _ready():
	flipper_action = "left_flipper" if flipper_side == "left" else "right_flipper"
	resting_transform = self.transform
	resting_rotation = self.rotation

func _input(event):
	if Input.is_action_just_pressed(flipper_action):
		flip()
	
	if Input.is_action_just_released(flipper_action):
		retract()
		

func _physics_process(delta):
	if flipping:
		apply_torque(transform.basis.y * 10)
	else:
		apply_torque(Vector3(0,0,0))

func _integrate_forces(state):
	# null out all force and torque that's not along the local y axis
	state.get_constant_torque()
	# and do something with the constant torque vector to get only the torque along the local y in global space
	
	state.integrate_forces()
