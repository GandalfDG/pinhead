extends Node

@onready var parent: Node = $".."
var scoring_elements: Array[Node]
var triggerable_elements: Array[Node]

# Called when the node enters the scene tree for the first time.
func _ready():
	# connect to scoring elements of the table
	scoring_elements = parent.find_children("*", "ScoringElement")
	for node in scoring_elements:
		node.connect("score", handle_scoring.bind(node.parent))
		
	# connect to triggerable elements of the table
	triggerable_elements = parent.find_children("*", "TriggerableElement")
	for node in triggerable_elements:
#		node.controller_connect(self)
		pass

func handle_scoring(element):
	print(element.name)

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
