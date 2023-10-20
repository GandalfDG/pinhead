extends Node3D

signal triggered
signal trigger_score

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_pop_trigger_body_entered(body):
	emit_signal("triggered")
	emit_signal("trigger_score")
