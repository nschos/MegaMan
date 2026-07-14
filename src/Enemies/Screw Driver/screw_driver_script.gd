class_name ScrewDriverEnemy extends Enemy

enum { IDLE, EXTENDING, SPINNING, RETRACTING, COOLDOWN }

@export var bullet_scene: PackedScene = preload("res://src/Enemies/Screw Driver/Bullet_inimigo8.tscn")
@export var damage_amount = 1
@export var attack_cooldown: float = 1.5
@export var rotation_offset_degrees: float = 0.0 

var current_state = IDLE
var player_ref: Node2D = null
var cooldown_timer: float = 0.0

@onready var sprite = $inimigo8
@onready var shoot_timer = $ShootTimer
@onready var spawn_point = $BulletSpawnNode

@onready var player_detector = $PlayerDetector 

func _ready() -> void:
	super()
	initial_HP = 3
	if not shoot_timer.timeout.is_connected(_on_shoot_timer_timeout):
		shoot_timer.timeout.connect(_on_shoot_timer_timeout)

func _reset() -> void:
	current_state = IDLE
	shoot_timer.stop()
	cooldown_timer = 0.0
	
	if sprite:
		sprite.play("idle")
		
	if player_ref == null:
		var players = get_tree().get_nodes_in_group("player")
		if players.size() > 0:
			player_ref = players[0]

func _physics_process(delta: float) -> void:
	match current_state:
		IDLE:
			if player_detector.has_overlapping_bodies():
				for body in player_detector.get_overlapping_bodies():
					if body.is_in_group("player"):
						start_extending()
						break 
						
		COOLDOWN:
			cooldown_timer += delta
			if cooldown_timer >= attack_cooldown:
				current_state = IDLE
				cooldown_timer = 0.0

func _on_player_detector_body_entered(body: Node2D) -> void:
	if current_state == IDLE and body.is_in_group("player"):
		start_extending()

func start_extending() -> void:
	current_state = EXTENDING
	if sprite:
		sprite.play("open") 
	await sprite.animation_finished
	start_spinning()

func start_spinning() -> void:
	current_state = SPINNING
	if sprite:
		sprite.play("spin_shoot")
	
	await get_tree().create_timer(0.3).timeout
	
	fire_spread_shot()
	shoot_timer.start(1.0)

func fire_spread_shot() -> void:
	SFXManager.play(SFXManager.ENEMY_SHOOT)
	# Ângulos originais (em radianos)
	var angles = [-PI, -3 * PI / 4, -PI / 2, -PI / 4, 0]
	
	var offset_rad = deg_to_rad(rotation_offset_degrees)
	
	for angle in angles:
		var direction = Vector2(cos(angle), sin(angle))
		
		var final_direction = direction.rotated(offset_rad)
		
		var bullet = bullet_scene.instantiate()
		bullet.global_position = spawn_point.global_position
		
		bullet.velocity = final_direction * 150.0 
		
		get_tree().current_scene.call_deferred("add_child", bullet)

func _on_shoot_timer_timeout() -> void:
	shoot_timer.stop()
	start_retracting()

func start_retracting() -> void:
	current_state = RETRACTING
	if sprite:
		sprite.play("close")
	await sprite.animation_finished
	
	current_state = COOLDOWN
	if sprite:
		sprite.play("idle")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.has_method("take_damage"):
		body.take_damage(damage_amount)
