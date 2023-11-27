@tool
extends CSGCombiner3D
class_name CSGPlayfield

# Pull up all PlayfieldCutout nodes out of child nodes to become direct children of us
# this is a dictionary with parent_node.name keys and array of cutout node values
var cutout_nodes: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	acquire_child_cutouts.call_deferred()

func _on_tree_entered():
	acquire_child_cutouts.call_deferred()


func acquire_child_cutouts():
	var cutout_parents = find_parents_of_cutouts()
	print(cutout_parents)

	for parent in cutout_parents:
		reparent_cutouts(parent)

	ping_emitters()


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

		for child in node.find_children("*", "", false, false):
			child.set_owner(node)

		var transform_emitter = TransformEmitter.new()
		transform_emitter.position = Vector3.ZERO
		parent_node.add_child(transform_emitter)
		transform_emitter.set_owner(parent_node)

		transform_emitter.transform_changed.connect(update_cutout_transform.bind(node))

func return_cutouts_to_parent(parent_node: Node):
	
	if cutout_nodes.has(parent_node.name):
		var cutouts_of_parent = cutout_nodes[parent_node.name]["children"]
		for cutout_node in cutouts_of_parent:
			cutout_node.reparent(parent_node)
			cutout_node.set_owner(parent_node)

		var transform_emitters_of_parent = parent_node.find_children("*", "TransformEmitter", true, false)
		for emitter in transform_emitters_of_parent:
			parent_node.remove_child(emitter)
			emitter.queue_free()

		cutout_nodes.erase(parent_node.name)
	

func update_cutout_transform(new_transform: Transform3D, node: Node):
		node.global_transform = new_transform

func ping_emitters():
	for emitter in find_children("*", "TransformEmitter", true, false):
		emitter.transform_changed.emit(emitter.global_transform)


func _on_child_entered_tree(_node: Node):
	acquire_child_cutouts.call_deferred()


func _on_child_exiting_tree(node):
	return_cutouts_to_parent.call_deferred(node)


func _on_child_order_changed():
	acquire_child_cutouts.call_deferred()
