@tool
extends Node3D

@export var flipper_angle: float = 30.0
@export var flipper_gap: float = 0.1

@onready var left_flipper = $FlipperLeft
@onready var right_flipper = $FlipperRight

# Place and orient flippers dynamically based on the export vars
func place_flippers():
	# Get the dimensions of the flipper bounding box
	var bounding_box = left_flipper.get_dimensions()
	print(bounding_box)
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	place_flippers()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	place_flippers()
	pass
