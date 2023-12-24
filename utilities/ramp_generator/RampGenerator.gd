@tool
extends Node3D

@export var curve_sample_interval = 0.2

@onready var ramp_surface = $RampSurfacePath
@onready var ramp_surface_mesh: MeshInstance3D = $RampSurfacePath/RampSurfaceMesh

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	pass

func generate_ramp_surface():
	var ramp_surface_curve: Curve3D = ramp_surface.curve
	var ramp_surface_points: PackedVector3Array = ramp_surface_curve.get_baked_points()
	var ramp_surface_up_vectors: PackedVector3Array = ramp_surface_curve.get_baked_up_vectors()

	var st: SurfaceTool = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in ramp_surface_points.size() / 2:
		var point_a = ramp_surface_points[i*2]
		var point_a_up = ramp_surface_up_vectors[i*2]
		var point_b = ramp_surface_points[i*2 + 1]
		var point_b_up = ramp_surface_up_vectors[i*2 + 1]

		# create a basis from the curve point's up vector
		var curve_point_a_basis = Basis.looking_at(point_a_up)
		var curve_point_b_basis = Basis.looking_at(point_b_up)
		
		# create a vector representing a movement from the curve point to
		# the right ramp edge point and transform it by the basis
		var right_edge_point_1 = Vector3(1, 0, 0) * curve_point_a_basis + point_a
		var left_edge_point_1 = Vector3(-1, 0, 0) * curve_point_a_basis + point_a
		var right_edge_point_2 = Vector3(1, 0, 0) * curve_point_b_basis + point_b
		var left_edge_point_2 = Vector3(-1, 0, 0) * curve_point_b_basis + point_b

		# generate a rectangle along the curve by creating two triangles
		st.add_vertex(right_edge_point_1)
		st.add_vertex(left_edge_point_1)
		st.add_vertex(right_edge_point_2)
		st.add_vertex(right_edge_point_2)
		st.add_vertex(left_edge_point_1)
		st.add_vertex(left_edge_point_2)

	st.generate_normals()
	st.generate_tangents()
	var mesh = st.commit()
	ramp_surface_mesh.set_mesh(mesh)

	pass

func _on_ramp_surface_path_curve_changed():
	print("hello")
	generate_ramp_surface()
	pass # Replace with function body.
