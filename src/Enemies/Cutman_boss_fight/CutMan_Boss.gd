class_name CutMan extends CharacterBody2D

@onready var throw_cooldown := $ThrowCooldown
@onready var sprite := $Sprite2D

@export var megaman: MegaMan
@export var rolling_cutter: RollingCutter

enum CutManState { IDLE, THROW, WALK, JUMP }
var current_state: CutManState = CutManState.IDLE

var assembled := true
var is_throw_in_colldown := false
var walk := false
var can_jump := true
var distance_to_megaman: float
var x_velocity: int = 0

const GRAVITY := 15
const WALK_SPEED := 90
const PURSUE_DISTANCE := 72
const JUMP_VELOCITY := -400
const throw_attack_distance := 48
const jump_attack_distance := 32

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	
	assert(megaman, "missing megaman in inspector!")
	
	if not self.is_on_floor():
		velocity.y += GRAVITY
	
	distance_to_megaman = self.global_position.distance_to(megaman.global_position)

		
	if current_state == CutManState.IDLE:
		if distance_to_megaman > PURSUE_DISTANCE:
			current_state = CutManState.WALK
			x_velocity = WALK_SPEED
			if is_megaman_in_the_left():
				x_velocity *= -1
		elif (_can_throw()):
			start_throw_animation()
		elif (distance_to_megaman < jump_attack_distance and
			  is_on_floor()):
				x_velocity = WALK_SPEED
				if is_megaman_in_the_left():
					x_velocity *= -1
				jump()
	
	elif current_state == CutManState.WALK:
		if (distance_to_megaman < jump_attack_distance and 
			is_on_floor()):
			jump()
		elif is_on_wall() and is_on_floor():
			jump()
		#else:
			
		pass
		
	elif current_state == CutManState.JUMP:
		if is_on_floor():
			current_state = CutManState.IDLE
			x_velocity = 0
		pass
		

	#
	#if (distance_to_megaman > PURSUE_DISTANCE and 
		#current_state != CutManState.WALK and 
		#is_on_floor()):
		#current_state = CutManState.WALK
		#self.velocity.x = WALK_SPEED
	#
		#if is_megaman_in_the_left():
			#self.velocity.x *= -1
			#
	#if (current_state != CutManState.IDLE and
		#distance_to_megaman > PURSUE_DISTANCE):
		#self.velocity.x = WALK_SPEED
		
	#
	#if (jump_attack_distance < distance_to_megaman and
		#distance_to_megaman < throw_attack_distance):
		#if assembled and is_throw_in_colldown:
			#start_throw_animation()
	#
	
	self.velocity.x = x_velocity
	
	sprite.flip_h = is_megaman_in_the_left()
	move_and_slide()
	
	
	pass
	
func try_jump_throw() -> void:
	if _can_throw():
		start_throw_animation()
	pass
	
func _can_throw() -> bool:
	return (not is_throw_in_colldown and
			assembled )#and
			#distance_to_megaman < throw_attack_distance)
	
func jump():
	#print("jump!")
	can_jump = false
	current_state = CutManState.JUMP
	velocity.y += JUMP_VELOCITY	
	
func take_rolling_cutter() -> void:
	assembled = true
	throw_cooldown.start()
	pass
	
func start_throw_animation() -> void:
	current_state = CutManState.THROW
	is_throw_in_colldown = true
	
func throw_rolling_cutter() -> void:
	assembled = false
	rolling_cutter.attack(megaman.global_position)
	
func is_megaman_in_the_left() -> bool:
	return megaman.global_position.x < self.global_position.x
	
func throw_ended() -> void:
	if not is_on_floor():
		current_state = CutManState.JUMP
	else:
		current_state = CutManState.IDLE
	pass

func _throw_cooldown_timeout() -> void:
	is_throw_in_colldown = false
	pass
