@tool
extends Node3D
class_name InsertBase

@export_color_no_alpha var base_color: Color:
	set(color):
		pattern_layer_material.set_shader_parameter("BaseColor", color)
		top_layer_material.set_shader_parameter("BaseColor", color)
		base_color = color

@export var pattern_layer_material: ShaderMaterial = preload("res://elements/playfield_inserts/insert_shader.material")
@export var top_layer_material: ShaderMaterial = preload("res://elements/playfield_inserts/insert_top_layer_material.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
#	pattern_layer_material.set_shader_parameter("BaseColor", base_color)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
