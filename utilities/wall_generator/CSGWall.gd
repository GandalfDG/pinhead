@tool
extends Path3D
class_name CSGWall

@onready var wall_geometry = $WallGeometry

# Called when the node enters the scene tree for the first time.
func _ready():
	wall_geometry.path_node = ".."
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_curve_changed():
	# pass the curve as the CSGPolygon's path node
	print("curve changed")
	pass # Replace with function body.
