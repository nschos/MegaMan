class_name MambuEnemy extends Enemy

enum { FLYING, SHOOTING }

@export var bullet_scene: PackedScene = preload("res://src/Enemies/Mambu/mambu_bullet.tscn")
@export var bullet_speed: float = 120.0 
@export var speed: float = 60.0
@export var attack_interval: float = 2.0 
@export var patrol_distance: float = 200.0
@export var start_facing_right: bool = true

var current_state = FLYING
var direction: int = 1 
var shoot_timer: Timer
var spawn_position: Vector2 

@onready var sprite = $inimigo6
@onready var spawn_point = $BulletSpawn

func _ready() -> void:
	super()
	initial_HP = 1
	spawn_position = position 
	
	shoot_timer = Timer.new()
	shoot_timer.wait_time = attack_interval
	shoot_timer.one_shot = true
	shoot_timer.timeout.connect(start_attack_sequence)
	add_child(shoot_timer)
	shoot_timer.start()

func _physics_process(delta: float) -> void:
	if current_state == FLYING:
		
		position.x += speed * direction * delta
		
		
		if abs(position.x - spawn_position.x) > patrol_distance:
			position = spawn_position 
			
			shoot_timer.start(attack_interval)

func start_attack_sequence() -> void:
	if current_state != FLYING: return
	
	current_state = SHOOTING
	if sprite: sprite.play("shooting")
	fire_8_way_shot()
	
	await get_tree().create_timer(0.5).timeout
	
	current_state = FLYING
	if sprite: sprite.play("idle")
	shoot_timer.start(attack_interval)

func fire_8_way_shot() -> void:
	SFXManager.play(SFXManager.ENEMY_SHOOT)
	for i in range(8):
		var angle = deg_to_rad(i * 45)
		var bullet = bullet_scene.instantiate()
		bullet.global_position = spawn_point.global_position
		
		if "velocity" in bullet:
			bullet.velocity = Vector2(cos(angle), sin(angle)) * bullet_speed
			
		get_tree().current_scene.call_deferred("add_child", bullet)

func _reset() -> void:
	position = spawn_position
	current_state = FLYING
	
	direction = 1 if start_facing_right else -1
	
	if sprite:
		sprite.flip_h = start_facing_right 
		sprite.play("idle")
		
	shoot_timer.start(attack_interval)


func _on_body_entered(body: Node2D) -> void:
	if body is MegaMan:
		body.take_damage(1)
