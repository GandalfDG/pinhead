extends ActivatedPhysicsBehavior

class_name SolenoidSpring

@export var solenoid_strength: float:
	set(strength):
		solenoid_strength = strength
		if solenoid_behavior && solenoid_behavior.is_node_ready():
			solenoid_behavior.solenoid_force = strength

@export var spring_strength: float:
	set(strength):
		spring_strength = strength
		if spring_behavior && spring_behavior.is_node_ready():
			spring_behavior.spring_stiffness = strength
			


@onready var solenoid_behavior = $Solenoid
@onready var spring_behavior = $AxisSpring

func _set(property, value):
	if property == "force_type":
		print("hello")
		set_force_type(value)

func set_force_type(value):
	solenoid_behavior.force_type = value
	spring_behavior.force_type = value
	force_type = value
	
# Called when the node enters the scene tree for the first time.
func _ready():
	spring_strength = spring_strength
	solenoid_strength = solenoid_strength
	spring_behavior.force_type = force_type
	solenoid_behavior.force_type = force_type
	solenoid_behavior.activation_type = activation_type
	solenoid_behavior.reverse_force = !reverse_force
	spring_behavior.reverse_force = reverse_force
	
func init(body):
	solenoid_behavior.init(body)
	spring_behavior.init(body)
	spring_behavior.spring_preload = 1

func activate(active: bool):
	solenoid_behavior.activate(active)
