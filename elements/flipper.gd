extends RigidBody3D

@export_enum("left", "right") var flipper_side: String = "left"
@export var flipper_torque: float = 100
@export var flip_angle: float = 25.0
@export var stop_margin: float = 1

var flipper_action: String = "left_flipper"
var resting_transform: Transform3D
var resting_rotation: Vector3
var default_damp: float

var flipping: bool = false
		
func flip():
#	constant_torque = Vector3()
#	add_constant_torque(Vector3(0, flipper_torque, 0) * global_transform.basis)
	flipping = true
	
func retract():
#	constant_torque = Vector3()
#	add_constant_torque(Vector3(0, -flipper_torque, 0) * global_transform.basis)
	flipping = false

# Called when the node enters the scene tree for the first time.
func _ready():
	flipper_action = "left_flipper" if flipper_side == "left" else "right_flipper"
	resting_transform = self.transform
	resting_rotation = self.rotation_degrees
	default_damp = angular_damp
	retract()
	
# the flipper should be stopped within a small range from the rest position
func at_retract_stop():
	var angle = rotation_degrees.y
	var boolean = angle < resting_rotation.y
	return boolean
	
func at_flip_stop():
	var angle = rotation_degrees.y
	return angle > flip_angle + resting_rotation.y

func _input(event):
	if Input.is_action_just_pressed(flipper_action):
		flip()
	
	if Input.is_action_just_released(flipper_action):
		retract()
		
func _physics_process(delta):
	pass


func _integrate_forces(state):
	
	var flipper_angle_fraction = (rotation_degrees.y - resting_rotation.y) / flip_angle
	var local_angular_velocity = angular_velocity * global_transform.basis
	var current_torque: Vector3 = Vector3()
	if flipping:
		var solenoid_accel_factor = 5
		var torque_magnitude = flipper_torque + solenoid_accel_factor * flipper_angle_fraction
		current_torque.y = torque_magnitude

		if at_flip_stop():
			if local_angular_velocity.y > 0:
				current_torque = current_torque - Vector3(0,current_torque.length()+1,0)
				angular_damp = 100
			else:
				current_torque = Vector3()
				angular_damp = default_damp
	else:
		var spring_accel_factor = 4
		var torque_magnitude = flipper_torque + spring_accel_factor * flipper_angle_fraction
		current_torque.y = -torque_magnitude

		if at_retract_stop():
			if local_angular_velocity.y < 0:
				current_torque = current_torque + Vector3(0,current_torque.length()+1,0)
				angular_damp = 100
			else:
				current_torque = Vector3()
				angular_damp = default_damp

	var transformed_torque = current_torque * global_transform.basis
	state.set_constant_torque(transformed_torque)
	# lock angular velocity to the flipper's local Y axis
	self.rotation_degrees.x=0
	self.rotation_degrees.z=0
	if rotation_degrees.y < resting_rotation.y:
		self.rotation_degrees.y = resting_rotation.y
	elif rotation_degrees.y > resting_rotation.y + flip_angle:
		self.rotation_degrees.y = resting_rotation.y + flip_angle
	
	state.integrate_forces()
