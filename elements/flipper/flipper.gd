extends "res://utilities/PhysicsBehavior.gd"

signal flipping(pressed)
signal enable

@export_enum("left", "right") var flipper_side: String = "left"

var flip_action: String
@onready var actuator: SolenoidSpring = $FlipperBody/SolenoidSpring

func _ready():
	flip_action = "left_flipper" if flipper_side == "left" else "right_flipper"
	actuator.reverse_force = flipper_side == "right"
	
func _physics_process(delta):
	if Input.is_action_just_pressed(flip_action):
		flipping.emit(true)
	if Input.is_action_just_released(flip_action):
		flipping.emit(false)

