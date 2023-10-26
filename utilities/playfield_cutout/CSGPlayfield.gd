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

func _on_tree_entered():
	pass # Replace with function body.


func acquire_child_cutouts():
	var cutout_parents = find_parents_of_cutouts()
	print(cutout_parents)

	for parent in cutout_parents:
		reparent_cutouts(parent)

# func acquire_child_cutouts(_new_node=null):
# 	# find nodes that have a direct PlayfieldCutout child
# 	var nodes_with_cutouts: Array = self.find_children("*","PlayfieldCutout", true, false).filter(
# 		func(node):
# 			return node.name != self.name
# 	).map(
# 		func(node: Node):
# 			return node.find_parent("*")
# 	).filter(func(parent):
# 		return not cutout_nodes.has(parent.name)
# 	)

# 	print("nodes_with_cutouts: " + str(nodes_with_cutouts))

# 	# append each direct PlayfieldCutout child of parent to an array, and put that array into the dictionary accessed by parent name
# 	for parent in nodes_with_cutouts:
		
# 		var cutouts: Array = parent.find_children("*", "PlayfieldCutout", false, false)
# 		# print("cutouts of " + parent.name + ": " + str(cutouts))

# 		if not cutout_nodes.has(parent.name):
# 			cutout_nodes[parent.name] = []
		
# 		for cutout in cutouts:
# 			cutout_nodes[parent.name].append(cutout)

# 	# reparent each cutout node to ourself
# 	# and put a TransformEmitter in the cutout's place
# 	reparent_cutouts()

# 	print(cutout_nodes)
# 	# print(find_children("*"))

func find_parents_of_cutouts():
	var parents_of_cutouts = find_children("*", "PlayfieldCutout", true, false).map(
		func(child_node):
			return child_node.find_parent("*")
	).filter(
		func(parent_node):
			return parent_node.name != self.name
	)
	return parents_of_cutouts

func reparent_cutouts(parent_node):
	var cutout_child_nodes = parent_node.find_children("*", "PlayfieldCutout", false, false)
	print("reparenting " + str(cutout_child_nodes) + " from " + parent_node.name)

	for node in cutout_child_nodes:
		if not cutout_nodes.has(parent_node.name):
			cutout_nodes[parent_node.name] = {"parent": parent_node, "children": []}
		cutout_nodes[parent_node.name]["children"].append(node)
		print(cutout_nodes)
		node.reparent(self)
		node.set_owner(self)

		var transform_emitter = TransformEmitter.new()
		transform_emitter.global_position = node.global_position
		parent_node.add_child(transform_emitter)
		transform_emitter.set_owner(parent_node)

		transform_emitter.transform_changed.connect(update_cutout_transform.bind(node))


# func reparent_cutouts():
# 	for parent_node_name in cutout_nodes:
# 		var parent_node = find_child(parent_node_name, true, false)
# 		# print("found child " + str(parent_node))
# 		# reparent the cutout nodes and own them
# 		for cutout in cutout_nodes[parent_node_name]:
# 			print("reparenting " + cutout.name + " to " + self.name)
# 			cutout.reparent(self)
# 			cutout.set_owner(self)

# 			# make sure the cutout owns all of its children as well
# 			for child in cutout.find_children("*", "", true, false):
# 				child.set_owner(cutout)

# 			# put a transform emitter where the cutout used to be
# 			var transform_emitter = TransformEmitter.new()
# 			transform_emitter.global_transform = cutout.global_transform
# 			transform_emitter.transform_changed.connect(update_cutout_transform.bind(cutout))
# 			print("adding child " + cutout.name + " to " + parent_node.name)
# 			parent_node.add_child(transform_emitter)
# 			transform_emitter.set_owner(parent_node)
	

func _on_child_entered_tree(node: Node):
	await node.ready
	# print(node.name + " ready")
	# print(str(node.find_children("*")))
	acquire_child_cutouts()


func update_cutout_transform(new_transform: Transform3D, node: Node):
		node.global_transform = new_transform



