extends Node3D

@onready var playfield: Node3D = $".."

var playfield_pickable_bodies: Array[Node]

var ball = preload("res://elements/ball.tscn")
var ball_instance: Node

var click_position: Vector3
var release_position: Vector3
# Called when the node enters the scene tree for the first time.
func _ready():
	# get the sibling objects on the playfield collision layer
	var static_children: Array[Node] = playfield.find_children("*", "StaticBody3D")
	playfield_pickable_bodies = static_children.filter(
		func(body: StaticBody3D): 
			return body.get_collision_layer_value(1))
	for body in playfield_pickable_bodies as Array[StaticBody3D]:
		body.connect("input_event", handle_playfield_click)


func handle_playfield_click(_camera, event, click_point, _normal, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		var click = event as InputEventMouseButton
		if click.is_pressed():
			click_position = click_point
		if click.is_released():
			release_position = click_point
			var velocity_vector: Vector3 = click_position.direction_to(release_position) * click_position.distance_to(release_position) * 10
			place_ball_with_velocity(click_position, velocity_vector)
			
func place_ball_with_velocity(origin: Vector3, velocity: Vector3):
	if ball_instance:
		ball_instance.queue_free()
	ball_instance = ball.instantiate()
	add_child(ball_instance)
	var ball_node = ball_instance as RigidBody3D
	
	# position the ball 
	ball_node.global_position = origin + 0.5 * Vector3.UP
	
	# give the ball an initial velocity
	ball_node.set_linear_velocity(velocity)

