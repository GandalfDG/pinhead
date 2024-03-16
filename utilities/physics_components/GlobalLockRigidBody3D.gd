extends RigidBody3D

class_name GlobalLockRigidBody

@export var lock_translation_x: bool = false
@export var lock_translation_y: bool = false
@export var lock_translation_z: bool = false
@export var lock_rotation_x: bool = false
@export var lock_rotation_y: bool = false
@export var lock_rotation_z: bool = false

@onready var resting_transform = self.global_transform
@onready var resting_origin = self.global_transform.origin * global_transform.basis.inverse()
@onready var resting_euler = self.global_transform.basis.get_euler()

var loop_count = 0

func _ready():
	pass

func _integrate_forces(state):
	loop_count += 1
	#state.integrate_forces()
	
	var state_transform = state.transform

	var state_origin = state_transform.origin

	# transform origin to local coordinates
	var local_origin = state_origin * global_transform.basis.inverse()

	local_origin = Vector3(
		resting_origin.x if lock_translation_x else local_origin.x,
		resting_origin.y if lock_translation_y else local_origin.y,
		resting_origin.z if lock_translation_z else local_origin.z
	)

	state_origin = local_origin * self.global_transform.basis

	var state_basis = state_transform.basis
	var local_basis = state_basis * global_transform.basis.inverse()
	var local_euler = local_basis.get_euler()

	local_euler = Vector3(
		resting_euler.x if lock_rotation_x else local_euler.x,
		resting_euler.y if lock_rotation_y else local_euler.y,
		resting_euler.z if lock_rotation_z else local_euler.z
	)

	state_basis = Basis.from_euler(local_euler * global_transform.basis)

	state_transform = Transform3D(state_basis, state_origin)
	if loop_count % 100 == 0:
		print(resting_origin, " ", local_origin)


	state.transform = state_transform
