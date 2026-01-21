extends Interactable

@export var cooldown: float = 2.0

@onready var audio: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var timer: Timer = Timer.new()

var can_interact := true

func _ready():
	timer.one_shot = true
	timer.wait_time = cooldown
	timer.timeout.connect(_on_cooldown_end)
	add_child(timer)

func get_prompt(_self) -> String:
	if can_interact:
		return "Открыть E"
	return ""

func interact(player):
	if not can_interact:
		return

	can_interact = false
	audio.play()
	
	player.has_checked_main_door = true
	
	player.get_node("SubtitleManager").show(
		"Надо поискать другой вход",
		2.0
	)

	timer.start()

func _on_cooldown_end():
	can_interact = true
