extends "res://utilities/PhysicsBehavior.gd"

signal flipping(pressed)
signal enable

@export_enum("left", "right") var flipper_side: String = "left"

var flip_action: String
@onready var actuator: SolenoidSpring = $FlipperBody/SolenoidSpring
@onready var body: RigidBody3D = $FlipperBody

func _ready():
	flip_action = "left_flipper" if flipper_side == "left" else "right_flipper"
	actuator.reverse_force = flipper_side == "right"
	
func mirror_flipper():
	# if it's a right flipper, mirror everything
	pass
	
	
func _physics_process(_delta):
	if Input.is_action_just_pressed(flip_action):
		flipping.emit(true)
	if Input.is_action_just_released(flip_action):
		flipping.emit(false)
	
	debug_flipper_velocity(body.angular_velocity)


###### Debugging stuff #######

var debug_max_flipper_velocity: float = 0
var debug_min_flipper_velocity: float = 10000000

func debug_flipper_velocity(velocity: Vector3):
	var local_velocity: Vector3 = velocity * global_transform.basis
	var y_velocity: float = (local_velocity * Vector3.UP).y

	if y_velocity > debug_max_flipper_velocity:
		debug_max_flipper_velocity = y_velocity
		print(self.name + " max velocity = " + str(debug_max_flipper_velocity))

	if y_velocity < debug_min_flipper_velocity:
		debug_min_flipper_velocity = y_velocity
		print(self.name + " min velocity = " + str(debug_min_flipper_velocity))
