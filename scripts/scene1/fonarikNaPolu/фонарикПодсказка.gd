extends Node3D

@onready var light = $SpotLight3D
@onready var mesh = $фонарик

var body_mat
var lamp_mat
var can_pick := false

func _ready():
	body_mat = mesh.get_active_material(0)
	lamp_mat = mesh.get_active_material(1)

	lamp_mat.emission_enabled = false
	body_mat.emission_enabled = false
	light.visible = false

func activate():
	can_pick = true
	light.visible = true
	lamp_mat.emission_enabled = true
	body_mat.emission_enabled = true
	start_blink()

func start_blink():
	var tween = create_tween()
	tween.set_loops()

	tween.tween_property(body_mat, "emission_energy_multiplier", 0.0, 1.0)
	tween.tween_property(body_mat, "emission_energy_multiplier", 0.05, 1.0)
