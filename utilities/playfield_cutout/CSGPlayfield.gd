@tool
extends CSGCombiner3D
class_name CSGPlayfield

# Pull up all PlayfieldCutout nodes out of child nodes to become direct children of us
var cutout_nodes: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_child_entered_tree(node: Node):
	await node.ready
	var cutouts = node.find_children("*", "PlayfieldCutout")
	if cutouts:
		cutout_nodes[node.name] = cutouts
		for cutout in cutouts:
			cutout.reparent(self)
			
	print(cutout_nodes)

func _on_child_exiting_tree(node):
	var cutouts = cutout_nodes.get(node.name)
	if cutouts:
		for cutout in cutouts:
			cutout.queue_free()
