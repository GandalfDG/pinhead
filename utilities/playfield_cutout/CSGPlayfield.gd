@tool
extends CSGCombiner3D
class_name CSGPlayfield

# Pull up all PlayfieldCutout nodes out of child nodes to become direct children of us
# this is a dictionary with node.name keys and array of cutout node values
var cutout_nodes: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	acquire_child_cutouts()

func _exit_tree():

	pass

func acquire_child_cutouts(new_node=null):
	# get every child PlayfieldCutout node recursively
	var cutout_child_nodes
	if new_node:
		cutout_child_nodes = new_node.find_children("*", "PlayfieldCutout")
	else:
		cutout_child_nodes = find_children("*", "PlayfieldCutout")

	print(cutout_child_nodes)

	for node in cutout_child_nodes:
		var parent_node = node.find_parent("*")
	
		if !cutout_nodes.has(parent_node.name):
			cutout_nodes[parent_node.name] = []
		
		cutout_nodes[parent_node.name].append(node)

		reparent_and_replace(node, parent_node)

	print(cutout_nodes)

func return_child_cutouts(parent_node: Node):
	if cutout_nodes.has(parent_node.name):
		# remove transform emitters
		var emitters = parent_node.find_children("*", "TransformEmitter", false)
		for emitter in emitters:
			emitter.queue_free()

		# return the cutout to its owner
		for node in cutout_nodes[parent_node.name]:
			node.reparent(parent_node)

		cutout_nodes.erase(parent_node.name)


func reparent_and_replace(cutout_node: Node, parent_node: Node):
	var transform_emitter = TransformEmitter.new()
	parent_node.add_child(transform_emitter)
	transform_emitter.connect("transform_changed", update_cutout_transform.bind(parent_node.name))
	cutout_node.reparent(self)
	
func _on_child_entered_tree(node: Node):
	await node.ready
	print(node.name + " ready")
	acquire_child_cutouts(node)
	

func _on_child_exiting_tree(node):
	return_child_cutouts(node)

func update_cutout_transform(new_transform: Transform3D, node_name: StringName):
	for cutout in cutout_nodes[node_name]:
		cutout.global_transform = new_transform
