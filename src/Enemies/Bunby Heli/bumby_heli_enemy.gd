class_name BunbyHeli extends Enemy

enum { PATROL, AIMING, DIVING }

@export var patrol_speed: float = 80.0
var current_state = PATROL
var player_ref: Node2D = null

@onready var dive_timer: Timer = $AttackTimer
var hover_y: float 
var is_active: bool = false  
var initial_position: Vector2

func _ready() -> void:
	super()
	initial_position = global_position
	set_process(true)
	set_physics_process(true)

	hover_y = global_position.y 
	
	if has_node("AttackTimer"):
		dive_timer = $AttackTimer
		if not dive_timer.timeout.is_connected(_on_attack_timer_timeout):
			dive_timer.timeout.connect(_on_attack_timer_timeout)

func _reset() -> void:
	current_state = PATROL
	is_active = true
	global_position = initial_position

func _physics_process(delta: float) -> void:
	if player_ref == null:
		find_player()
		return
		
	if not visible_notifier.is_on_screen():
		is_active = false
		return
	
	if not is_active:
		is_active = true
		if current_state == PATROL and dive_timer.is_stopped():
			dive_timer.start(0.1)

	match current_state:
		PATROL:
			_patrol_logic(delta)
		AIMING:
			pass
		DIVING:
			pass

func _patrol_logic(delta: float) -> void:
	var dist_x = abs(global_position.x - player_ref.global_position.x)
	var direction = sign(player_ref.global_position.x - global_position.x)
	if direction == 0: direction = 1
	
	update_sprite_direction(direction)
	
	if dist_x > 32:
		global_position.x += patrol_speed * direction * delta
	elif dist_x < 32:
		global_position.x -= patrol_speed * direction * delta

func _on_attack_timer_timeout() -> void:
	if current_state == PATROL and player_ref:
		var dist_x = abs(global_position.x - player_ref.global_position.x)
		
		if dist_x <= 32:
			_start_aiming()
		else:
			dive_timer.start(0.01)

func _start_aiming() -> void:
	current_state = AIMING
	await get_tree().create_timer(0.1).timeout 
	
	if is_active:
		_perform_v_swoop()

func _perform_v_swoop() -> void:
	current_state = DIVING
	
	var dive_target = player_ref.global_position
	var direction = sign(player_ref.global_position.x - global_position.x)
	if direction == 0: direction = 1
	
	var exit_target = Vector2(dive_target.x + (56 * direction), hover_y)
	
	var tween = create_tween()
	
	tween.tween_property(self, "global_position:x", dive_target.x, 0.4).set_trans(Tween.TRANS_LINEAR)
	tween.parallel().tween_property(self, "global_position:y", dive_target.y, 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	
	tween.tween_property(self, "global_position:x", exit_target.x, 0.4).set_trans(Tween.TRANS_LINEAR)
	tween.parallel().tween_property(self, "global_position:y", exit_target.y, 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	tween.tween_callback(func(): 
		current_state = PATROL
		if is_active:
			dive_timer.start(0.1) 
	
		update_sprite_direction(direction)

	)

func update_sprite_direction(dir: int) -> void:
	var sprite = $inimigo1
	if dir > 0:
		sprite.flip_h = true
	elif dir < 0:
		sprite.flip_h = false

func find_player() -> void:
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player_ref = players[0]


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.has_method("take_damage"):
		body.take_damage(3)
