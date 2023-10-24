@tool
extends Node3D
class_name TransformEmitter

signal transform_changed(new_transform)

var previous_transform: Transform3D

# Called when the node enters the scene tree for the first time.
func _ready():
	previous_transform = global_transform

func _process(_delta):
	if global_transform != previous_transform:
		transform_changed.emit(global_transform)
		previous_transform = global_transform
