extends Interactable

@export var note_texture: Texture2D

@onready var audio1: AudioStreamPlayer3D = $"ВзялиЗаписку"
@onready var audio2: AudioStreamPlayer3D = $"ПоложилиЗаписку"

var note_open := false
var note_ui : TextureRect
var cached_player

func _ready():
	note_ui = get_tree().get_current_scene().get_node("UI/NoteUI")
func get_prompt(_player):
	return "Закрыть [E]" if note_open else "Прочитать записку [E]"


func interact(player):
	cached_player = player

	if note_open:
		close_note()
	else:
		open_note()

func open_note():
	note_open = true
	note_ui.show()
	audio1.play()

	cached_player.input_locked = true
	cached_player.set_physics_process(false)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func close_note():
	note_open = false
	note_ui.hide()
	audio2.play()
	
	cached_player.input_locked = false
	cached_player.set_physics_process(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(_delta):
	if note_open and Input.is_action_just_pressed("ui_cancel"):
		close_note()
