@tool
extends CurvedGeometry
class_name RampGenerator

@export_range(0.05,1) var curve_sample_interval: float:
	set(value):
		curve_sample_interval = value
		ramp_surface.curve.bake_interval = value
		generate_ramp_surface()
@export_range(0.05,1) var ramp_base_thickness: float:
	set(value):
		ramp_base_thickness = value
		generate_ramp_surface()

@onready var ramp_surface = $RampSurfacePath
@onready var ramp_surface_mesh: MeshInstance3D = $RampSurfacePath/RampSurfaceMesh
@onready var ramp_entrance: Marker3D = $RampSurfacePath/RampEntrancePoint
@onready var ramp_exit: Marker3D = $RampSurfacePath/RampExitPoint

var curve_point_basis_cache: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func create_curve_point_basis(point_a: Vector3, point_b: Vector3, tilt: float) -> Basis:
	var curve_point_basis = curve_point_basis_cache.get(point_a)
	if !curve_point_basis:
		# create a basis from a vector between point a and point b and the tilt angle
		var curve_direction_vector = point_b - point_a
		# project the vector onto the x-z plane to become the forward axis of the first basis
		var projection = curve_direction_vector
		projection.y = 0
		projection = projection.normalized()

		curve_point_basis = Basis.looking_at(projection, Vector3.UP, false)

		var tilt_angle = projection.angle_to(curve_direction_vector)

		curve_point_basis = curve_point_basis.rotated(curve_point_basis.x, tilt_angle)
		curve_point_basis = curve_point_basis.rotated(curve_point_basis.z, -tilt)
		curve_point_basis_cache[point_a] = curve_point_basis

	return curve_point_basis


func generate_ramp_surface():
	# reset basis cache
	curve_point_basis_cache = Dictionary()

	var ramp_surface_curve: Curve3D = ramp_surface.curve
	var ramp_surface_points: PackedVector3Array = ramp_surface_curve.get_baked_points()
	var ramp_surface_tilts: PackedFloat32Array = ramp_surface_curve.get_baked_tilts()

	var st: SurfaceTool = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	#for i in range(0,3):
	for i in ramp_surface_points.size() - 2:
		var point_a = ramp_surface_points[i]
		var point_a_tilt = ramp_surface_tilts[i]
		var point_b = ramp_surface_points[i + 1]
		var point_b_tilt = ramp_surface_tilts[i + 1]
		var point_c = ramp_surface_points[i + 2]

		
		var curve_point_basis_a = create_curve_point_basis(point_a, point_b, point_a_tilt)
		var curve_point_basis_b = create_curve_point_basis(point_b, point_c, point_b_tilt)
		
		# create a vector representing a movement from the curve point to
		# the right ramp edge point and transform it by the basis
		var right_edge_point_1 = curve_point_basis_a * Vector3(1, 0, 0) + point_a

		var left_edge_point_1 = curve_point_basis_a * Vector3(-1, 0, 0) + point_a


		var right_edge_point_2 = curve_point_basis_b * Vector3(1, 0, 0) + point_b
		var left_edge_point_2 = curve_point_basis_b * Vector3(-1, 0, 0) + point_b

		var ramp_thickness_vector = Vector3(0, -ramp_base_thickness, 0)
		
		var bottom_right_point_1 = right_edge_point_1 + curve_point_basis_a * ramp_thickness_vector 
		var bottom_left_point_1 = left_edge_point_1 + curve_point_basis_a * ramp_thickness_vector
		var bottom_right_point_2 = right_edge_point_2 + curve_point_basis_b * ramp_thickness_vector
		var bottom_left_point_2 = left_edge_point_2 + curve_point_basis_b * ramp_thickness_vector

		# debug

		# top surface
		st.add_vertex(right_edge_point_1)
		st.add_vertex(left_edge_point_1)
		st.add_vertex(left_edge_point_2)

		st.add_vertex(right_edge_point_1)
		st.add_vertex(left_edge_point_2)
		st.add_vertex(right_edge_point_2)

		# bottom surface
		st.add_vertex(bottom_right_point_1)
		st.add_vertex(bottom_left_point_2)
		st.add_vertex(bottom_left_point_1)

		st.add_vertex(bottom_right_point_1)
		st.add_vertex(bottom_right_point_2)
		st.add_vertex(bottom_left_point_2)

		# left edge
		st.add_vertex(left_edge_point_1)
		st.add_vertex(bottom_left_point_1)
		st.add_vertex(left_edge_point_2)

		st.add_vertex(left_edge_point_2)
		st.add_vertex(bottom_left_point_1)
		st.add_vertex(bottom_left_point_2)

		# right edge
		st.add_vertex(right_edge_point_1)
		st.add_vertex(right_edge_point_2)
		st.add_vertex(bottom_right_point_1)

		st.add_vertex(right_edge_point_2)
		st.add_vertex(bottom_right_point_2)
		st.add_vertex(bottom_right_point_1)
		
		# start endcap
		if i == 0:
			ramp_entrance.global_transform = Transform3D(curve_point_basis_a, point_a)
			st.add_vertex(right_edge_point_1)
			st.add_vertex(bottom_right_point_1)
			st.add_vertex(bottom_left_point_1)
			
			st.add_vertex(bottom_left_point_1)
			st.add_vertex(left_edge_point_1)
			st.add_vertex(right_edge_point_1)
			
		# end endcap
		if i == ramp_surface_points.size() - 3:
			ramp_exit.global_transform = Transform3D(curve_point_basis_b, point_b)
			st.add_vertex(right_edge_point_2)
			st.add_vertex(bottom_left_point_2)
			st.add_vertex(bottom_right_point_2)
			
			st.add_vertex(bottom_left_point_2)
			st.add_vertex(right_edge_point_2)
			st.add_vertex(left_edge_point_2)

	st.generate_normals()
	st.generate_tangents()
	var mesh = st.commit()
	ramp_surface_mesh.set_mesh(mesh)


func _on_ramp_surface_path_curve_changed():
	generate_ramp_surface()
	pass # Replace with function body.