extends Node3D

signal spin

@export var axis_offset: float = .015

@onready var axis_node = $Axis

# Called when the node enters the scene tree for the first time.
func _ready():
	axis_node.position.y = axis_offset


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
