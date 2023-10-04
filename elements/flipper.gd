extends Node3D

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

# Called when the node enters the scene tree for the first time.
func _ready():
	flipper_action = "left_flipper" if flipper_side == "left" else "right_flipper"
	resting_transform = self.transform
	resting_rotation = self.rotation
#
#	flipper_fire_tween = self.create_tween().set_trans(Tween.TRANS_CUBIC)

func _input(event):
	if Input.is_action_just_pressed(flipper_action):
		kill_current_tween()
		var flipper_fire_tween = self.create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
		flipper_fire_tween.tween_property(self, "rotation", resting_rotation + Vector3(0, deg_to_rad(flip_angle if flipper_side == "left" else -flip_angle), 0), flip_duration)
		current_tween = flipper_fire_tween
	
	if Input.is_action_just_released(flipper_action):
		kill_current_tween()
		var return_duration = flip_duration * (abs(rad_to_deg(self.rotation.y))/flip_angle)
		var flipper_return_tween = self.create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		flipper_return_tween.tween_property(self, "rotation", resting_rotation, return_duration)

		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
