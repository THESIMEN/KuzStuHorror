extends Interactable

func get_prompt(_player):
	var root = owner
	if root.can_pick:
		return "Взять фонарик [E]"
	return ""

func interact(player):
	var root = owner

	if not root.can_pick:
		return

	player.obtain_flashlight()
	root.queue_free()
