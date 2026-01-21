extends CharacterBody3D

@export var speed: float = 4.0
@export var mouse_sensitivity: float = 0.001
@export var gravity: float = 9.8

@onready var camera: Camera3D = $Camera3D
@onready var ray := $Camera3D/RayCast3D
@onready var prompt_label: Label = $"../UI/подсказки"

var has_checked_main_door := false
var has_bolt_cutter := true

var rotation_x: float = 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):#Ескейп
	# Переключение курсора по ESC
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	# Поворот камеры ТОЛЬКО когда мышь захвачена
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)

		rotation_x -= event.relative.y * mouse_sensitivity
		rotation_x = clamp(rotation_x, deg_to_rad(-89), deg_to_rad(89))
		camera.rotation.x = rotation_x

func _physics_process(delta):#Ходить
	var input_dir = Vector3.ZERO

	if Input.is_action_pressed("move_forward"):
		input_dir -= transform.basis.z
	if Input.is_action_pressed("move_back"):
		input_dir += transform.basis.z
	if Input.is_action_pressed("move_left"):
		input_dir -= transform.basis.x
	if Input.is_action_pressed("move_right"):
		input_dir += transform.basis.x

	input_dir = input_dir.normalized()

	velocity.x = input_dir.x * speed
	velocity.z = input_dir.z * speed

	# Гравитация
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0.0
	move_and_slide()

func _process(_delta):#ПодсказкаПриНаведении
	if ray.is_colliding():
		var obj = ray.get_collider()
		if obj is Interactable:
			show_prompt(obj.get_prompt(self))
			if Input.is_action_just_pressed("interact"):
				obj.interact(self)
		else:
			hide_prompt()
	else:
		hide_prompt()

func show_prompt(text: String):
	prompt_label.text = text
	prompt_label.visible = true

func hide_prompt():
	prompt_label.visible = false
