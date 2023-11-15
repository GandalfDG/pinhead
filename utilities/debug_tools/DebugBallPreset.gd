@tool
extends Marker3D
class_name DebugBallPreset

@export var velocity_magnitude: float = 10:
	set(value):
		velocity_vector = velocity_vector.normalized() * value
		velocity_magnitude = value

@onready var direction_marker = $PresetDirection

var velocity_vector: Vector3 = Vector3()

func _ready():
	var direction: Vector3 = position.direction_to(direction_marker.position)
	velocity_vector = direction * velocity_magnitude
