extends Node

@onready var label: Label = $"../../UI/SubtitleLabel"
@onready var timer: Timer = Timer.new()

func _ready():
	label.visible = false
	timer.one_shot = true
	timer.timeout.connect(_hide)
	add_child(timer)

func show(text: String, time: float = 2.5):
	label.text = text
	label.visible = true
	timer.start(time)

func _hide():
	label.visible = false
