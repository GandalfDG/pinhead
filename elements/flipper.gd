extends Node3D

signal flipping(pressed)

@export_enum("left", "right") var flipper_side: String = "left"
@export var flip_angle: float = 30.0
@export var flip_torque: float = 30.0
@export var return_torque: float = 15

var flip_action: String

func _ready():
	flip_action = "left_flipper" if flipper_side == "left" else "right_flipper"
	
func _physics_process(delta):
	if Input.is_action_just_pressed(flip_action):
		flipping.emit(true)
	if Input.is_action_just_released(flip_action):
		flipping.emit(false)

#func _input(event):
#	if event.is_action_pressed(flip_action):
#		flipping.emit(true)
#	else:
#		flipping.emit(false)
