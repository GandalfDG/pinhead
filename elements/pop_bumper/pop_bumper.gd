extends Node3D

signal triggered

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_pop_trigger_body_entered(body):
	emit_signal("triggered")
