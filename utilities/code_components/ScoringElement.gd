@tool
extends Node

signal score

@onready var parent: Node = $".."


var scoring_nodes: Array[Node] = []

func _get_configuration_warnings():
	var warnings = []
	if scoring_nodes.size() < 1:
		warnings.append("No sibling nodes emit a score signal")

	return warnings

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect to any score signals in the parent's tree
	var nodes = parent.find_children("*")
	nodes.append(parent)
	scoring_nodes = nodes.filter(func(node):
		return node.has_signal("trigger_score")
	)

	for node in scoring_nodes:
		node.connect("trigger_score", signal_score)

	# Connect to parent's signals
	parent.connect("child_order_changed", update_configuration_warnings)
	update_configuration_warnings()

func signal_score():
	score.emit()
