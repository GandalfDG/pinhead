extends Node3D

@onready var playfield: Node3D = $".."

var playfield_pickable_bodies: Array[Node]

var click_position: Vector3
var release_position: Vector3
# Called when the node enters the scene tree for the first time.
func _ready():
	# get the sibling objects on the playfield collision layer
	var static_children: Array[Node] = playfield.find_children("*", "StaticBody3D")
	playfield_pickable_bodies = static_children.filter(
		func(body: StaticBody3D): 
			return body.get_collision_layer_value(1) or body.get_collision_layer_value(2))
	for body in playfield_pickable_bodies as Array[StaticBody3D]:
		body.connect("input_event", handle_playfield_click)


func handle_playfield_click(_camera, event, position, _normal, _shape_idx):
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		var click = event as InputEventMouseButton
		if click.is_pressed():
			click_position = position
		if click.is_released():
			release_position = position
			print(click_position)
			print(release_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		var position: Vector2 = event.global_position
#		var playfield_location = get_playfield_location(position)
