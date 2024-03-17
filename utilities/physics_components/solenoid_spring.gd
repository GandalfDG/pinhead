extends ActivatedPhysicsBehavior

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

# Called when the node enters the scene tree for the first time.
func _ready():
	solenoid_behavior.solenoid_force = solenoid_strength
	spring_behavior.spring_stiffness = spring_strength
	
func init(body):
	solenoid_behavior.init(body)
	
	spring_behavior.init(body)
	spring_behavior.spring_preload = 1

func activate(active: bool):
	solenoid_behavior.activate(active)
