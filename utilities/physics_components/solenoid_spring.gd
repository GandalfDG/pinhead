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

@export var reverse_force: bool:
	set(reverse):
		pass

var solenoid_behavior = null
var spring_behavior = null

# Called when the node enters the scene tree for the first time.
func _ready():
	solenoid_behavior = $Solenoid
	spring_behavior = $AxisSpring
	
func init(body):
	solenoid_behavior.init(body)
	spring_behavior.init(body)
	spring_behavior.spring_preload = 1

func activate(active: bool):
	solenoid_behavior.activate(active)
