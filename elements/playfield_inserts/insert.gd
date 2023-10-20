@tool
extends Node3D
class_name InsertBase

@export_color_no_alpha var base_color: Color:
	set(color):
		pattern_layer_material.set_shader_parameter("BaseColor", color)
		top_layer_material.set_shader_parameter("BaseColor", color)
		base_color = color

@export var pattern_layer_material: ShaderMaterial = preload("res://elements/playfield_inserts/materials/insert_pattern.material")
@export var top_layer_material: ShaderMaterial = preload("res://elements/playfield_inserts/materials/insert_top_layer.material")

@onready var pattern_layer_mesh: MeshInstance3D = $PatternedSurface
@onready var top_layer_mesh: MeshInstance3D = $FlatSurface

# Called when the node enters the scene tree for the first time.
func _ready():
	pattern_layer_mesh.mesh.surface_set_material(0, pattern_layer_material)
	top_layer_mesh.mesh.surface_set_material(0, top_layer_material)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
