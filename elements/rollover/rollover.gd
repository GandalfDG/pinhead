extends Node3D

signal trigger_score

@onready var rollover_body = $RolloverBody
@onready var rollover_rest_transform = rollover_body.global_transform

var displaced = false

func _physics_process(delta):
	var rollover_displacement = (rollover_body.global_transform.origin - rollover_rest_transform.origin).length()
	if not displaced and rollover_displacement > 0.2:
		displaced = true
		trigger_score.emit()
	
	if displaced and rollover_displacement < 0.1:
		displaced = false
	
