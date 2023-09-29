extends Node3D

@export_enum("left", "right") var flipper_side: String = "left"

var flipper_action: String = "left"

# Called when the node enters the scene tree for the first time.
func _ready():
	flipper_action = "left_flipper" if flipper_side == "left" else "right_flipper"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed(flipper_action):
		# play flipper animation (though this may be more in-depth with some custom physics)
		rotation.y = 1
	else:
		rotation.y = 0
