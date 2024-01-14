@tool
extends Node3D

@export var curve_sample_interval = 0.2
@export var ramp_base_thickness: float = 0.1

@onready var ramp_surface = $RampSurfacePath
@onready var ramp_surface_mesh: MeshInstance3D = $RampSurfacePath/RampSurfaceMesh

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func create_curve_point_basis(point_a: Vector3, point_b: Vector3, tilt: float) -> Basis:
	# create a basis from a vector between point a and point b and the tilt angle
	var curve_direction_vector = point_b - point_a
	# project the vector onto the x-z plane to become the forward axis of the first basis
	var projection = curve_direction_vector
	projection.y = 0
	projection = projection.normalized()

	var curve_point_basis = Basis().looking_at(projection * -1, Vector3.DOWN, false)

	var tilt_angle = curve_point_basis.z.angle_to(curve_direction_vector)
	curve_point_basis = curve_point_basis.rotated(Vector3.LEFT, tilt_angle)
	curve_point_basis = curve_point_basis.rotated(Vector3.FORWARD, tilt)
	return curve_point_basis

func generate_ramp_surface():
	var ramp_surface_curve: Curve3D = ramp_surface.curve
	var ramp_surface_points: PackedVector3Array = ramp_surface_curve.get_baked_points()
	var ramp_surface_up_vectors: PackedVector3Array = ramp_surface_curve.get_baked_up_vectors()
	var ramp_surface_tilts: PackedFloat32Array = ramp_surface_curve.get_baked_tilts()

	var st: SurfaceTool = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in ramp_surface_points.size() - 2:
		var point_a = ramp_surface_points[i]
		var point_a_up = ramp_surface_up_vectors[i]
		var point_a_tilt = ramp_surface_tilts[i]
		var point_b = ramp_surface_points[i + 1]
		var point_b_up = ramp_surface_up_vectors[i + 1]
		var point_b_tilt = ramp_surface_tilts[i + 1]
		var point_c = ramp_surface_points[i + 2]

		var curve_point_basis_a = create_curve_point_basis(point_a, point_b, point_a_tilt)
		var curve_point_basis_b = create_curve_point_basis(point_b, point_c, point_b_tilt)

		# create a vector representing a movement from the curve point to
		# the right ramp edge point and transform it by the basis
		var right_edge_point_1 = Vector3(1, 0, 0) * curve_point_basis_a + point_a
		var left_edge_point_1 = Vector3(-1, 0, 0) * curve_point_basis_a + point_a

		var right_edge_point_2 = Vector3(1, 0, 0) * curve_point_basis_b + point_b
		var left_edge_point_2 = Vector3(-1, 0, 0) * curve_point_basis_b + point_b
		
		var ramp_thickness_vector = Vector3(0, ramp_base_thickness, 0)

		# top surface
		st.add_vertex(right_edge_point_1)
		st.add_vertex(left_edge_point_1)
		st.add_vertex(left_edge_point_2)
		
		st.add_vertex(right_edge_point_1)
		st.add_vertex(left_edge_point_2)
		st.add_vertex(right_edge_point_2)
		
		# bottom surface
		st.add_vertex(right_edge_point_1 + ramp_thickness_vector * curve_point_basis_a)
		st.add_vertex(left_edge_point_2  + ramp_thickness_vector * curve_point_basis_b)
		st.add_vertex(left_edge_point_1  + ramp_thickness_vector * curve_point_basis_a)
		
		st.add_vertex(right_edge_point_1 + ramp_thickness_vector * curve_point_basis_a)
		st.add_vertex(right_edge_point_2  + ramp_thickness_vector * curve_point_basis_b)
		st.add_vertex(left_edge_point_2  + ramp_thickness_vector * curve_point_basis_b)
		
		# left edge
		st.add_vertex(left_edge_point_1)
		st.add_vertex(left_edge_point_1  + ramp_thickness_vector * curve_point_basis_a)		
		st.add_vertex(left_edge_point_2)
		
		st.add_vertex(left_edge_point_2)
		st.add_vertex(left_edge_point_1  + ramp_thickness_vector * curve_point_basis_a)		
		st.add_vertex(left_edge_point_2  + ramp_thickness_vector * curve_point_basis_b)
		
		# right edge
		st.add_vertex(right_edge_point_1)
		st.add_vertex(right_edge_point_2)
		st.add_vertex(right_edge_point_1  + ramp_thickness_vector * curve_point_basis_a)		
		
		st.add_vertex(right_edge_point_2)
		st.add_vertex(right_edge_point_2  + ramp_thickness_vector * curve_point_basis_b)		
		st.add_vertex(right_edge_point_1  + ramp_thickness_vector * curve_point_basis_a)		

	st.generate_normals()
	st.generate_tangents()
	var mesh = st.commit()
	ramp_surface_mesh.set_mesh(mesh)


func _on_ramp_surface_path_curve_changed():
	generate_ramp_surface()
	pass # Replace with function body.
