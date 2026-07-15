class_name KamadomaEnemy extends Enemy

enum { IDLE, JUMPING }

@export var jump_force_y: float = 300.0
@export var jump_speed_x: float = 120.0
@export var jump_interval: float = 1.0

var current_state = IDLE
var player_ref: Node2D = null
var jump_timer: Timer
var spawn_position: Vector2 
var is_active = false
var velocity: Vector2 = Vector2.ZERO 
var custom_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite = $inimigo4
@onready var floor_detector = $RayCast2D

func _ready() -> void:
	super()
	initial_HP = 1 
	spawn_position = global_position 
	
	jump_timer = Timer.new()
	jump_timer.wait_time = jump_interval
	jump_timer.one_shot = true
	jump_timer.timeout.connect(perform_jump)
	add_child(jump_timer)
	jump_timer.start(jump_interval) 

func _reset() -> void:
	visible = true
	set_process(true)
	set_physics_process(true)
	current_state = IDLE
	velocity = Vector2.ZERO
	global_position = spawn_position
	
	is_active = false 
	
	if sprite: 
		sprite.play("idle")

func _physics_process(delta: float) -> void:
	if player_ref == null: find_player()
	
	if player_ref != null:
		var is_on_screen = visible_notifier.is_on_screen()
		var distance = global_position.distance_to(player_ref.global_position)

		if is_on_screen and distance < 300: 
			if not is_active:
				is_active = true
				perform_jump() 
				jump_timer.start(jump_interval)
		else:
			if is_active:
				is_active = false
				jump_timer.stop()
				current_state = IDLE 
				if sprite: sprite.play("idle")

	velocity.y += custom_gravity * delta
	global_position += velocity * delta
	
	if floor_detector.is_colliding():
		if velocity.y > 0: 
			velocity.y = 0
			global_position.y = floor_detector.get_collision_point().y - 10 
			if current_state == JUMPING:
				land()
	else:
		if current_state == IDLE and is_active: 
			current_state = JUMPING
			if sprite: sprite.play("jump")
	
	match current_state:
		IDLE:
			velocity.x = move_toward(velocity.x, 0, 600 * delta)
		JUMPING:
			pass

func perform_jump() -> void:
	if not is_active: return 
	
	current_state = JUMPING
	if sprite: sprite.play("jump")
		
	var direction = 1
	if player_ref and is_instance_valid(player_ref):
		direction = sign(player_ref.global_position.x - global_position.x)
	
	if sprite: sprite.flip_h = direction < 0
	
	velocity.y = -jump_force_y
	velocity.x = jump_speed_x * direction

func land() -> void:
	current_state = IDLE
	velocity.x = 0 
	velocity.y = 0 
	
	if sprite: sprite.play("idle")
	
	if is_active:
		jump_timer.start(jump_interval)

func find_player() -> void:
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player_ref = players[0]

func _despawn() -> void:
	
	current_state = IDLE
	velocity = Vector2.ZERO
	jump_timer.stop() 
	
	if sprite: 
		sprite.play("idle")

	despawned.emit()

func _on_body_entered(body: Node2D) -> void:
	if body is MegaMan:
		body.take_damage(1)
