extends Node
class_name TriggerableElement

signal trigger

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func trigger_behavior():
	trigger.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
