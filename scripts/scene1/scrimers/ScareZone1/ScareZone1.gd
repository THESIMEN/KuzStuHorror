extends Node3D

@export var scare_duration := 0.6

@onready var area = $Area3D
@onready var sound = $AudioStreamPlayer3D
@onready var ghost = $"."

var triggered := false

func _ready():
	ghost.hide()
	area.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if triggered:
		return

	if not body.is_in_group("player"):
		return

	if not GameState.screamer1_read:
		return

	triggered = true
	play_scare()


func play_scare():
	ghost.show()
	sound.play()

	await get_tree().create_timer(scare_duration).timeout
	ghost.hide()
