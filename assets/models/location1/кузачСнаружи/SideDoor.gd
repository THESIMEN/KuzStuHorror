extends Interactable

@export var цепиДверные: NodePath
@export var cooldown: float = 2.0

@onready var chains = get_node(цепиДверные)
@onready var chain_on_door = chains.get_node("цепьНаДВери")
@onready var chain_on_ground = chains.get_node("цепьНаПолу")
@onready var audio: AudioStreamPlayer3D = $"Заперто"
@onready var audio2: AudioStreamPlayer3D = $"ЦепьУпала"

@onready var timer: Timer = Timer.new()

var is_locked := true
var can_interact := true

func _ready():
	timer.one_shot = true
	timer.wait_time = cooldown
	timer.timeout.connect(func(): can_interact = true)
	add_child(timer)

func get_prompt(player) -> String:
	if not player.has_checked_main_door:
		return ""
	if not can_interact:
		return ""
	if is_locked:
		return "Осмотреть замок [E]"
	return "Открыть [E]"

func interact(player):
	if not player.has_checked_main_door or not can_interact:
		return

	can_interact = false

	if is_locked:
		if player.has_bolt_cutter:
			is_locked = false
			chain_on_door.visible = false
			chain_on_ground.visible = true

			audio2.play()
			player.get_node("SubtitleManager").show(
				"Я срезал цепь",
				2.0
			)
		else:
			player.need_bolt_cutter = true
			audio.play()
			player.get_node("SubtitleManager").show(
				"Цепь... нужен инструмент",
				2.0
			)
			GameState.screamer1_read = true
			await get_tree().create_timer(2.5).timeout
			$"../../../взаимодействие/горшокПодсказка".fall()
	else:
		print("Дверь откроется дальше")

	timer.start()
