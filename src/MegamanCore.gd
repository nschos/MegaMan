class_name MegaMan extends CharacterBody2D

const RUNNING_FULLSPEED_X    := 82.5 # 01.60
const RUNNING_DECELERATION_X := 30.0 # 00.80
const RUNNING_ACCELERATION_X := 7.5  # 00.20
const JUMP_X_SPEED = 78.75
const JUMP_VELOCITY = -292.265625
const CLIMB_SPEED = 45
const GRAVITY = 15

enum Direction { LEFT = -1, RIGHT = 1 }

var last_direction := Direction.RIGHT

var is_facing_direction: Direction = Direction.RIGHT

const shooting_window := 15
var shooting_frame_counter := 0

var respawn_position: Vector2
var has_control: bool = true

var blink_timer := 0
const blink_max_time := 168

var bullets: Array[MegamanBullet] = []

var is_shooting := false


var is_jumping := false

var jump_flag := true

var is_touching_ladder := false
var has_ladder_under := false
var ladder_x := 0
	
var has_grabbed_ladder = false

@onready var animation_player: AnimatedSprite2D = %AnimatedSprite2D
@onready var state_machine := $StateMachine

@onready var collision_shape := $CollisionShape2D2


func _ready() -> void:
	respawn_position = global_position
	add_to_group("player")
	#get_tree().current_scene.add_child.call_deferred(bullet)
	for child in get_children():
		if child is MegamanBullet:
			child.reparent.call_deferred(get_tree().current_scene)
			bullets.append(child)
	

func _physics_process(_delta: float) -> void:
	#print(Engine.get_physics_frames())
	
	if is_shooting:
		shooting_frame_counter += 1
		if shooting_frame_counter == shooting_window:
			is_shooting = false
	
	if not has_control:
		velocity = Vector2.ZERO 
		move_and_slide()
		return
	
	if blink_timer > blink_max_time:
		blink_timer = 0
		
	#print("char:",Engine.get_frames_drawn())
	
	#print(position)
	#print(get_slide_collision_count())
	
	if velocity.x > 0:
		is_facing_direction = Direction.RIGHT
		animation_player.flip_h = true
	elif velocity.x < 0:
		is_facing_direction = Direction.LEFT
		animation_player.flip_h = false
	
	if not is_on_floor() and state_machine.state is not MegaMan_State_Climbing:
		velocity.y += GRAVITY
	
	if state_machine.state is not MegaMan_State_Climbing:
		
		if ((Input.is_action_pressed("ui_up") and is_touching_ladder) or
			(Input.is_action_pressed("ui_down") and has_ladder_under)):
			#has_grabbed_ladder = true
			#print(collision_mask)
			state_machine.state.finished.emit(MegaManState.CLIMBING)
			self.position.x = ladder_x
		
		if state_machine.state is not MegaMan_State_Running:
			if is_on_floor() and velocity.x != 0:
				state_machine.state.finished.emit(MegaManState.RUNNING)
				pass
		# Handle jump.
		if Input.is_action_pressed("jump") and is_on_floor() and jump_flag:
			state_machine.state.finished.emit(MegaManState.JUMPING)
			is_jumping = true
			jump_flag = false
			
		if !Input.is_action_pressed("jump"):
			jump_flag = true
		
	
	if Input.is_action_just_pressed("NES_B_button"):
		_shoot_bullet()
		
		
	#if Input.is_action_just_pressed("NES_A_button"):
		

	move_and_slide()
	
	blink_timer += 1

func _shoot_bullet() -> void:
	for bullet in bullets:
		if not bullet.bullet_moving:
			#bullet.position = self.global_position
			bullet.position.y = self.global_position.y + 4
			if state_machine.state is not MegaMan_State_Climbing:
				if animation_player.flip_h:
					bullet.position.x = self.global_position.x + 20
					bullet.shoot(Direction.RIGHT)
				else:
					bullet.position.x = self.global_position.x - 20
					bullet.shoot(Direction.LEFT)
			else:
				if Input.is_action_pressed("ui_left"):
					bullet.position.x = self.global_position.x - 20
					bullet.shoot(Direction.LEFT)
					animation_player.flip_h = false
				elif Input.is_action_pressed("ui_right"):
					bullet.position.x = self.global_position.x + 20
					bullet.shoot(Direction.RIGHT)
					animation_player.flip_h = true
				else:
					bullet.position.x = self.global_position.x + 20
					bullet.shoot(Direction.RIGHT)
					animation_player.flip_h = true
					
				
				
				
			shooting_frame_counter = 0
			is_shooting = true
				
			return
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("megaman touched ladder")
	is_touching_ladder = true
	
	_calculate_ladder_x(body)
	
	pass # Replace with function body.


func _on_area_2d_body_exited(_body: Node2D) -> void:
	if ((state_machine.state is MegaMan_State_Climbing) and has_control) or \
		state_machine.state is not MegaMan_State_Climbing:
		print("megaman untouched ladder")
		is_touching_ladder = false
		has_grabbed_ladder = false
		self.set_collision_mask_value(3, true)
		state_machine.state.finished.emit(MegaManState.IDLE)
		self.velocity.y = 0
	pass # Replace with function body.


func _on_lower_ladder_detection_body_entered(body: Node2D) -> void:
	print("ladder under!")
	has_ladder_under = true
	_calculate_ladder_x(body)
	#is_touching_ladder = true
	pass # Replace with function body.


func _on_lower_ladder_detection_body_exited(_body: Node2D) -> void:
	if has_control:
		print("no ladder under!")
		has_ladder_under = false
	pass # Replace with function body.
	
func _calculate_ladder_x(body: Node2D) -> void:
	var local_pos: Vector2 = body.to_local(global_position)
	var tile_grid_coords: Vector2i = body.local_to_map(local_pos)
	var tile_local_center: Vector2 = body.map_to_local(tile_grid_coords)
	var tile_global_pos: Vector2 = body.to_global(tile_local_center)
	ladder_x = int(tile_global_pos.x)
	pass
	
func death() -> void:
	print("O jogador morreu!")
	
	has_control = false
	velocity = Vector2.ZERO
	process_mode = PROCESS_MODE_DISABLED
	hide()
	
	#need to add animation
	await get_tree().create_timer(1.0).timeout 
	
	respawn()

func respawn() -> void:
	print("Jogador respawnou!")
	
	global_position = respawn_position
	
	process_mode = PROCESS_MODE_INHERIT
	show()
	has_control = true
	
	if animation_player.sprite_frames.has_animation("idle"):
		animation_player.play("idle")
