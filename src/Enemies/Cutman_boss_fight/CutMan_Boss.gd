class_name CutMan extends CharacterBody2D

@export var assembled := true
@export var jump_speed := 300
@export var rolling_cutter: RollingCutter
@export var attack_distance := 48
@export var pursue_distance := 72
@export var megaman: MegaMan
@export var jump_attack_distance := 32

@onready var throw_cooldown := $ThrowCooldown

@onready var sprite := $Sprite2D

enum CutManState { IDLE, THROW, WALK, JUMP }

@export var current_state: CutManState = CutManState.WALK
var can_throw := true
var walk := false
var distance_to_megaman: float

const GRAVITY := 15
const WALK_SPEED := 90





func jump():
	print("CutMan Jump!")
	velocity.y += -300



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rolling_cutter.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	assert(megaman, "missing megaman in inspector!")
	
	
	distance_to_megaman = self.global_position.distance_to(megaman.global_position)
	
	if current_state == CutManState.WALK:
		if is_on_wall():
			current_state = CutManState.JUMP
			self.velocity.y = -jump_speed
	
	if current_state == CutManState.JUMP and is_on_floor():
		current_state = CutManState.IDLE 
	
	if distance_to_megaman > pursue_distance and current_state != CutManState.WALK:
		current_state = CutManState.WALK
		self.velocity.x = WALK_SPEED
	
		if is_megaman_in_the_left():
			self.velocity.x *= -1
			
	if current_state == CutManState.WALK:
		if is_megaman_in_the_left() and self.velocity.x > 0:
			self.velocity.x *= -1
	
	if distance_to_megaman < attack_distance:
		if assembled and can_throw:
			current_state = CutManState.THROW
		elif is_on_floor():
			current_state = CutManState.JUMP
			velocity.y = -jump_speed
	
	#if assembled and can_throw  and current_state != CutManState.THROW: 
		#current_state = CutManState.THROW
				
	
	if not self.is_on_floor():
		velocity.y += GRAVITY
		
	sprite.flip_h = is_megaman_in_the_left()
	
	move_and_slide()
	
	pass
	
func take_rolling_cutter() -> void:
	throw_cooldown.start()
	pass
	
func throw_rolling_cutter() -> void:
	assembled = false
	can_throw = false
	rolling_cutter.attack(megaman.global_position)
	
func is_megaman_in_the_left() -> bool:
	return megaman.global_position.x < self.global_position.x
	
func throw_ended() -> void:
	#print("throw ended!")
	current_state = CutManState.IDLE
	pass


func _throw_cooldown_timeout() -> void:
	can_throw = true
	pass # Replace with function body.
