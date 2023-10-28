@tool
extends Node3D
class_name PlayfieldInsert

@export_group("Shape")
@export var insert_cup_mesh: Mesh = preload("res://elements/playfield_inserts/meshes/default_insert_cup.tres")

@export_group("Color")
@export_color_no_alpha var base_color: Color:
	set(color):
		if pattern_layer_mesh:
			pattern_layer_mesh.set_instance_shader_parameter("BaseColor", color)
		if top_layer_mesh:
			top_layer_mesh.set_instance_shader_parameter("BaseColor", color)
		base_color = color
		
@export_group("Lighting")
@export var material_emission_multiplier: float = 1:
	set(multiplier):
		if pattern_layer_mesh:
			pattern_layer_mesh.set_instance_shader_parameter("EmissionMultiplier", multiplier)
		if top_layer_mesh:
			top_layer_mesh.set_instance_shader_parameter("EmissionMultiplier", multiplier)
		material_emission_multiplier = multiplier

@export var pattern_layer_material: ShaderMaterial = preload("res://elements/playfield_inserts/materials/insert_pattern.material")
@export var top_layer_material: ShaderMaterial = preload("res://elements/playfield_inserts/materials/insert_top_layer.material")

@onready var top_layer_mesh: MeshInstance3D = $Meshes/TopSurface
@onready var pattern_layer_mesh: MeshInstance3D = $Meshes/PatternedSurface
@onready var bulb_light: Light3D = $Lighting/BulbLight

# Called when the node enters the scene tree for the first time.
func _ready():
	pattern_layer_mesh.mesh.surface_set_material(0, pattern_layer_material)
	top_layer_mesh.mesh.surface_set_material(0, top_layer_material)
	
	set_editable_instance(bulb_light, true)




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
