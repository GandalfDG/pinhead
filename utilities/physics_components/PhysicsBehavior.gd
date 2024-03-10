extends Node3D

class_name PhysicsBehavior

var body_rest_transform: Transform3D
var physics_body: RigidBody3D:
	set(body):
		physics_body = body
		body_rest_transform = body.transform

func _ready():
	pass

func process_behavior(_delta):
	pass
