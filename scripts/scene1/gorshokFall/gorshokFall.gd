extends Node3D
@export var flashlight_path: NodePath

@onready var flashlight = $"../фонарик"
@onready var sound = $"горшокУпал/Упал"

var fallen := false

func fall():
	if fallen:
		return

	fallen = true
	$"горшокСтоит".hide()
	$"горшокУпал".show()
	$"горшокУпал/StaticBody3D/CollisionShape3D".disabled = false
	$"горшокУпал/запискаВГоршке/записка/StaticBody3D/CollisionShape3D".disabled = false
	sound.play()
	
	flashlight.activate()
