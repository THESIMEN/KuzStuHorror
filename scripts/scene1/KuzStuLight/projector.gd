extends Node3D

# ===== НАСТРОЙКИ =====
@export var flicker_min_energy := 0.6      # минимальная энергия Spot при мигании
@export var flicker_max_energy := 0.85     # максимальная энергия Spot при мигании
@export var event_interval := 1          # среднее время между попытками моргания
@export var event_interval_random := 1.0   # вариация интервала
@export var chance_per_light := 0.2        # вероятность, что конкретный источник моргнет
@export var flicker_duration := 0.07       # длительность моргания (сек)

# ===== ВНУТРЕННЕЕ =====
var rng := RandomNumberGenerator.new()
var sources := []  # список пар Spot + Omni

func _ready():
	rng.randomize()

	# собираем все пары Spot + Omni
	for child in get_children():
		if child is SpotLight3D:
			var omni := child.get_node_or_null("OmniLight3D")
			sources.append({
				"spot": child,
				"omni": omni,
				"spot_base": child.light_energy,
				"omni_base": omni.light_energy if omni else 0
			})

	start_event_loop()

func start_event_loop():
	while true:
		# ждем случайное время между морганиями
		await get_tree().create_timer(
			event_interval + rng.randf_range(-event_interval_random, event_interval_random)
		).timeout

		for s in sources:
			if rng.randf() < chance_per_light:
				flicker_source(s)

func flicker_source(s):
	var spot: SpotLight3D = s.spot
	var omni: OmniLight3D = s.omni

	# Spot мерцает на короткое мгновение
	var e = rng.randf_range(flicker_min_energy, flicker_max_energy)
	spot.light_energy = e

	# Omni моргает относительно своей базовой энергии из инспектора
	if omni:
		omni.light_energy = s.omni_base * rng.randf_range(0.4, 0.7)

	# короткая пауза
	await get_tree().create_timer(flicker_duration).timeout

	# возвращаем Spot и Omni в нормальное состояние
	spot.light_energy = s.spot_base
	if omni:
		omni.light_energy = s.omni_base
