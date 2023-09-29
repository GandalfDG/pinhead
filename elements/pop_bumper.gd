extends Node3D

var kicker_animation: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	kicker_animation = $Kicker/AnimationPlayer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_pop_trigger_body_entered(_body: Node3D):
	# trigger the kicker mechanism
	kicker_animation.play("pop kick")
