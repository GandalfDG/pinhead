extends RigidBody3D

@export_enum("left", "right") var flipper_side: String = "left"
@export var flip_duration: float = .035
@export var flip_angle: float = 25.0

var flipper_action: String = "left_flipper"
var resting_transform: Transform3D
var resting_rotation: Vector3

var current_tween: Tween = null

func kill_current_tween():
	if current_tween:
		current_tween.kill()
		current_tween = null
		
func flip():
	apply_torque(Vector3(0,1,0))
	
func retract():
	pass


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
		
#func _integrate_forces(state):
#	if rotation.y >= flip_angle:
#		apply_torque(Vector3(0,0,0))
	
#func _integrate_forces(state: PhysicsDirectBodyState3D):
#	if rotation.y >= flip_angle:
#		rotation.y = flip_angle
#	integrate_forces
#
#	pass

