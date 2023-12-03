@tool
extends Path3D
class_name CSGWall

@onready var wall_geometry = $WallGeometry
@onready var mesh_instance = $WallPhysicsBody/WallMesh
@onready var collision_shape = $WallPhysicsBody/WallCollisionShape

# Called when the node enters the scene tree for the first time.
func _ready():
	wall_geometry.path_node = ".."
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_curve_changed():
	# get the mesh from the csg polygon
	var meshes_array = wall_geometry.get_meshes()
	var mesh_transform = meshes_array[0]
	var mesh_data = meshes_array[1]
	
	# set it as the mesh resource for the mesh_instance
	mesh_instance.set_mesh(mesh_data)
	
	# generate a trimesh collision from the mesh instance for the collision shape
	var trimesh_shape = mesh_data.create_trimesh_shape()
	collision_shape.set_shape(trimesh_shape)

