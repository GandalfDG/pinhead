@tool
extends CSGCombiner3D
class_name CSGPlayfield

# Pull up all PlayfieldCutout nodes out of child nodes to become direct children of us
# this is a dictionary with node.name keys and array of cutout node values
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
		cutout_nodes[node.name] = []
		for cutout in cutouts:
			cutout_nodes[node.name].append(cutout)
			cutout.reparent(self)
			cutout.set_owner(get_tree().edited_scene_root)
			var transform_emitter = TransformEmitter.new()
			node.add_child(transform_emitter)
			transform_emitter.set_owner(get_tree().edited_scene_root)
			transform_emitter.connect("transform_changed", update_cutout_transform.bind(node.name))
			
	else:
		print("weewoo")
			
	print(cutout_nodes)

func _on_child_exiting_tree(node):
	var cutouts = cutout_nodes.get(node.name)
	if cutouts:
		for cutout in cutouts:
			cutout.reparent(node)

func update_cutout_transform(new_transform: Transform3D, node_name: StringName):
	for cutout in cutout_nodes[node_name]:
		cutout.global_transform = new_transform
