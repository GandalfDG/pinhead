@tool
extends Node3D

@onready var left_flipper: Node = $FlipperLeft
@onready var right_flipper: Node = $FlipperRight

@export_range(0,90, 0.1, "degrees") var flipper_angle: float = 30:
	set(value):
		flipper_angle = value
		if Engine.is_editor_hint():
			place_flippers()
		
@export_range(0,2,.01) var flipper_gap: float = 0.1:
	set(value):
		flipper_gap = value
		if Engine.is_editor_hint():
			place_flippers()
			
#var flipper_endpoint = Marker3D.new()

#var node_ready: bool = false

# Place and orient flippers dynamically based on the export vars
func place_flippers():
	# Rotate the flippers to their desired resting angle
	var left_flipper_rotated: Transform3D = Transform3D().rotated(Vector3(0,1,0), deg_to_rad(-flipper_angle))
	var right_flipper_rotated: Transform3D = Transform3D().rotated(Vector3(0,1,0), deg_to_rad(180+flipper_angle))
	left_flipper.set_transform(left_flipper_rotated)
	right_flipper.set_transform(right_flipper_rotated)

	# Get the dimensions of the flipper bounding box
	var flipper_mesh: MeshInstance3D = left_flipper.get_node("FlipperMesh")
	var bounding_box = flipper_mesh.get_mesh().get_aabb()
	
#	flipper_endpoint.position = bounding_box.end
	
	var origin_to_end_distance = bounding_box.end.x
	left_flipper.set_transform(left_flipper_rotated.translated(Vector3(- (flipper_gap/2),0,0)))
	right_flipper.set_transform(right_flipper_rotated.translated(Vector3((flipper_gap/2),0,0)))


# Called when the node enters the scene tree for the first time.
func _ready():
#	add_child(flipper_endpoint)
#	flipper_endpoint.owner = self
#	node_ready = true
#	if Engine.is_editor_hint():
	place_flippers()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	place_flippers()
	pass


