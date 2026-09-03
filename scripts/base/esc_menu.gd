extends Control

@onready var player_sensitivity = $"../../player"


func _ready():
	$".".hide()

func reset_menu():
	$esc.show()
	$setting.hide()

func _on_button_1_pressed() -> void:
	$".".hide()
	$"../../player".set_physics_process(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_button_3_pressed() -> void:
	get_tree().quit()


func _on_button_2_pressed() -> void:
	$esc.hide()
	$setting.show()


func _on_h_slider_value_changed(value: float) -> void:
	player_sensitivity.mouse_sensitivity = value
