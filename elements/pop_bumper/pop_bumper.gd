extends Node3D

signal triggered
signal trigger_score

@onready var kicker_behavior: ActivatedPhysicsBehavior = $Kicker/Kicker/SolenoidSpring
@onready var kicker_body: RigidBody3D = $Kicker/Kicker
@onready var slider_joint: SliderJoint3D = $Kicker/SliderJoint3D

# Called when the node enters the scene tree for the first time.
func _ready():
	kicker_behavior.init($Kicker/Kicker)


func _on_pop_trigger_body_entered(body):
	kicker_behavior.activate(true)
	
func _physics_process(_delta):
	if (kicker_behavior.body_rest_transform.origin - kicker_body.transform.origin).length() > .8 * slider_joint.get_param(slider_joint.PARAM_LINEAR_LIMIT_UPPER):
		kicker_behavior.activate(false)
