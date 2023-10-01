extends Node3D

@export_enum("left", "right") var flipper_side: String = "left"

var flipper_action: String = "left"
var resting_transform

# Called when the node enters the scene tree for the first time.
func _ready():
	flipper_action = "left_flipper" if flipper_side == "left" else "right_flipper"
	resting_transform = self.transform

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed(flipper_action):
		# play flipper animation (though this may be more in-depth with some custom physics)
		self.transform = resting_transform.rotated_local(Vector3(0,1,0), deg_to_rad( 20 if flipper_side == "left" else -20))
		pass
	else:
		self.transform = resting_transform
		pass
