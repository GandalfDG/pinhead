@tool
extends RigidBody3D
class_name pinball

@onready var ball_mesh: MeshInstance3D = $MeshInstance3D
@onready var ball_collider: CollisionShape3D = $CollisionShape3D

@export var ball_radius: float = 0.5
#	set(value):
#		ball_radius = value
#		if ball_mesh:
#			var sphere_mesh = ball_mesh.mesh as SphereMesh
#			sphere_mesh.radius = value
#			sphere_mesh.height = value
#		if ball_collider:
#			ball_collider.shape.radius = ball_radius
