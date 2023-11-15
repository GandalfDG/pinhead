extends Node3D

signal trigger_score

@export var axis_offset: float = .015

@onready var axis_node = $Axis
@onready var spinner_body = $SpinnerBody

var inverted: bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	axis_node.position.y = axis_offset

var max_rotation = 0

func _physics_process(delta):
	var spinner_rotation = rad_to_deg((Vector3.UP * spinner_body.transform.basis).angle_to(Vector3.UP))
#	if spinner_rotation > max_rotation:
#		max_rotation = spinner_rotation
#		print(max_rotation)
	if spinner_rotation > 120:
		inverted = true
	
	if spinner_rotation < 90:
		if inverted:
			trigger_score.emit()
			inverted = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
