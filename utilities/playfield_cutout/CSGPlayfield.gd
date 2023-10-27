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
			var cutout_dupe = node.duplicate()
			self.add_child(cutout_dupe)
			cutout_dupe.set_owner(self)
			for child in cutout_dupe.find_children("*"):
				child.set_owner(cutout_dupe)

		# var transform_emitter = TransformEmitter.new()
		# transform_emitter.global_position = node.global_position
		# parent_node.add_child(transform_emitter)
		# transform_emitter.set_owner(parent_node)

		# transform_emitter.transform_changed.connect(update_cutout_transform.bind(node))

	

func _on_child_entered_tree(node: Node):
	await node.ready
	# print(node.name + " ready")
	# print(str(node.find_children("*")))
	acquire_child_cutouts()


func update_cutout_transform(new_transform: Transform3D, node: Node):
		node.global_transform = new_transform

