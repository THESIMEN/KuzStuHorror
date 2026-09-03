extends Interactable

@onready var audio: AudioStreamPlayer3D = $"подобрали"

func get_prompt(player):
	if not player.need_bolt_cutter or player.has_bolt_cutter:
		return ""
	return "Взять болторез [E]"

func interact(player):
	if not player.need_bolt_cutter:
		
		player.get_node("SubtitleManager").show(
				"хм...",
				2.0
			)
		return
	$"..".hide()
	audio.play()
	player.has_bolt_cutter = true

	await audio.finished
	$"..".queue_free()
