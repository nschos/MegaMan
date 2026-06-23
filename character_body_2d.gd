class_name MegaMan extends CharacterBody2D

const SPEED = 82.5
const JUMP_VELOCITY = -292.265625
const GRAVITY = 15

var respawn_position: Vector2
var has_control: bool = true

var blink_timer := 0
const blink_max_time := 168


var is_jumping := false

var is_touching_ladder := false
var ladder_x := 0
	
var has_grabbed_ladder = false

@onready var animation_player := %AnimatedSprite2D
@onready var state_machine := $StateMachine

func _ready() -> void:
	respawn_position = global_position
	add_to_group("player")

func _physics_process(delta: float) -> void:
	
	if not has_control:
		velocity = Vector2.ZERO 
		move_and_slide()
		return
	
	if blink_timer > blink_max_time:
		blink_timer = 0
		
	
	
	#print(position)
	#print(get_slide_collision_count())
	
	if not is_on_floor() and state_machine.state is not MegaMan_State_Climbing:
		velocity.y += GRAVITY
	
	if state_machine.state is not MegaMan_State_Climbing:
		
		if (Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down")) and is_touching_ladder:
			#has_grabbed_ladder = true
			#print(collision_mask)
			state_machine.state.finished.emit(MegaManState.CLIMBING)
			self.position.x = ladder_x
		
		if state_machine.state is not MegaMan_State_Running:
			if is_on_floor() and velocity.x != 0:
				state_machine.state.finished.emit(MegaManState.RUNNING)
				pass
		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			state_machine.state.finished.emit(MegaManState.JUMPING)
			is_jumping = true
			
			
		#if state_machine.state is MegaMan_State_Running:
		var direction := Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			

	move_and_slide()
	
	blink_timer += 1


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("megaman touched ladder")
	is_touching_ladder = true
	
	var local_pos: Vector2 = body.to_local(global_position)
	#print(local_pos)
	var tile_grid_coords: Vector2i = body.local_to_map(local_pos)
	#print(tile_grid_coords)
	var tile_local_center: Vector2 = body.map_to_local(tile_grid_coords)
	var tile_global_pos: Vector2 = body.to_global(tile_local_center)
	
	ladder_x = tile_global_pos.x
	
	pass # Replace with function body.


func _on_area_2d_body_exited(body: Node2D) -> void:
	print("megaman untouched ladder")
	is_touching_ladder = false
	has_grabbed_ladder = false
	self.set_collision_mask_value(3, true)
	pass # Replace with function body.

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
