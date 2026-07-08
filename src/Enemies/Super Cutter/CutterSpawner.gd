extends Node2D

@export var cutter_scene: PackedScene 
@export var spawn_cooldown: float = 1.5 

@export_enum("Esquerda:-1", "Direita:1") var default_direction: int = -1

@onready var spawn_timer: Timer = $SpawnTimer
@onready var spawn_point: Marker2D = $SpawnPoint
@onready var trigger_zone: Area2D = $TriggerZone # Adicionada a referência ao nó

var player_ref: Node2D = null

func _ready() -> void:
	spawn_timer.wait_time = spawn_cooldown

	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	#trigger_zone.body_entered.connect(_on_trigger_zone_body_entered)
	#trigger_zone.body_exited.connect(_on_trigger_zone_body_exited)

func _on_trigger_zone_body_entered(body: Node2D) -> void:
	print("entrou na area")
	if body.is_in_group("player"):
		player_ref = body 
		_spawn_cutter()
		spawn_timer.start()


func _on_trigger_zone_body_exited(body: Node2D) -> void:
	print("saiu da area")
	if body == player_ref:
		player_ref = null 
		spawn_timer.stop()


func _on_spawn_timer_timeout() -> void:
	_spawn_cutter()


func _spawn_cutter() -> void:
	if not cutter_scene:
		return
		
	var cutter = cutter_scene.instantiate()
	
	# Posição inicial da tesoura
	cutter.global_position = spawn_point.global_position
	
	if player_ref:
		# 1. Qual a distância horizontal entre a máquina e o Mega Man?
		var distance_x = abs(player_ref.global_position.x - global_position.x)
		
		# 2. Calcula o tempo total que a tesoura ficará no ar (Subida + Descida)
		var time_in_air = (2.0 * abs(cutter.jump_force)) / cutter.fall_gravity
		
		# 3. Ajusta a velocidade horizontal para cobrir a distância nesse tempo exato
		cutter.horizontal_speed = distance_x / time_in_air
		
		# 4. Define a direção para a qual ela deve voar
		if player_ref.global_position.x < global_position.x:
			cutter.direction = -1
			cutter.get_node("inimigo3").flip_h = false
		else:
			cutter.direction = 1
			cutter.get_node("inimigo3").flip_h = true
	else:
		# Se não houver alvo, joga com a direção padrão
		cutter.direction = default_direction

	# Adiciona a tesoura à cena
	get_tree().current_scene.call_deferred("add_child", cutter)
		
	# Inicia o movimento com os novos valores
	if cutter.has_method("spawn"):
		cutter.spawn()
