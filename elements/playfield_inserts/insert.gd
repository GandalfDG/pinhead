@tool
extends Node3D
class_name InsertBase

@export_color_no_alpha var base_color: Color:
	set(color):
		insert_material.set_shader_parameter("BaseColor", color)
		base_color = color

@export var insert_material: ShaderMaterial = preload("res://elements/playfield_inserts/insert_shader.material")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
