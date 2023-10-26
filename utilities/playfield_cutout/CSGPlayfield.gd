@tool
extends CSGCombiner3D
class_name CSGPlayfield

# Pull up all PlayfieldCutout nodes out of child nodes to become direct children of us
# this is a dictionary with node.name keys and array of cutout node values
var cutout_nodes: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	print(name + " ready")
	# acquire_child_cutouts()
	

func _on_tree_exiting():
	for parent_node in cutout_nodes.keys():
		for node in cutout_nodes[parent_node.name]:
			node.reparent(parent_node)


func _on_tree_entered():
	print(name + " entered tree")
	print(find_children("*"))
	print(cutout_nodes)
	pass # Replace with function body.


func acquire_child_cutouts(_new_node=null):
	# find nodes that have a direct PlayfieldCutout child
	var nodes_with_cutouts: Array = self.find_children("*","PlayfieldCutout", true, false).map(
		func(node: Node):
			return node.find_parent("*")
	)

	print("nodes_with_cutouts: " + str(nodes_with_cutouts))

	# append each direct PlayfieldCutout child of parent to an array, and put that array into the dictionary accessed by parent name
	for parent in nodes_with_cutouts:
		
		var cutouts: Array = parent.find_children("*", "PlayfieldCutout", false, false)
		print("cutouts of " + parent.name + ": " + str(cutouts))

		if not cutout_nodes.has(parent.name):
			cutout_nodes[parent.name] = []
		
		for cutout in cutouts:
			cutout_nodes[parent.name].append(cutout)

	# reparent each cutout node to ourself
	# and put a TransformEmitter in the cutout's place
	reparent_cutouts()

	print(cutout_nodes)
	print(find_children("*"))

func reparent_cutouts():
	for parent_node_name in cutout_nodes:
		var parent_node = find_child(parent_node_name, true, false)
		print("found child " + str(parent_node))
		# reparent the cutout nodes and own them
		for cutout in cutout_nodes[parent_node_name]:
			cutout.reparent(self)
			cutout.set_owner(self)

			# make sure the cutout owns all of its children as well
			for child in cutout.find_children("*", "", true, false):
				child.set_owner(cutout)

			# put a transform emitter where the cutout used to be
			var transform_emitter = TransformEmitter.new()
			transform_emitter.global_transform = cutout.global_transform
			transform_emitter.transform_changed.connect(update_cutout_transform.bind(cutout))
			parent_node.add_child(transform_emitter)
			transform_emitter.set_owner(parent_node)


# func return_child_cutouts(parent_node: Node):
# 	if cutout_nodes.has(parent_node.name):
# 		# remove transform emitters
# 		var emitters = parent_node.find_children("*", "TransformEmitter", false)
# 		for emitter in emitters:
# 			emitter.queue_free()

# 		# return the cutout to its owner
# 		for node in cutout_nodes[parent_node.name]:
# 			return_to_parent.call_deferred(node, parent_node)

# 		cutout_nodes.erase(parent_node.name)


# func reparent_and_replace(cutout_node: Node, parent_node: Node):
# 	var transform_emitter: TransformEmitter = TransformEmitter.new()
# 	parent_node.add_child(transform_emitter)
# 	transform_emitter.connect("transform_changed", update_cutout_transform.bind(parent_node.name))
# 	cutout_node.reparent(self)

# func return_to_parent(node: PlayfieldCutout, parent_node: Node):
# 	remove_child(node)
# 	parent_node.add_child(node as PlayfieldCutout)
# 	node.set_owner(parent_node)
	

func _on_child_entered_tree(node: Node):
	await node.ready
	print(node.name + " ready")
	print(str(node.find_children("*")))
	acquire_child_cutouts(node)
	

# func _on_child_exiting_tree(node):
# 	print("returning cutouts to " + node.name)
# 	return_child_cutouts(node)
# 	print(cutout_nodes)


func update_cutout_transform(new_transform: Transform3D, node: Node):
		node.global_transform = new_transform



