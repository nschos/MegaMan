class_name CutMan extends CharacterBody2D

@export var assembled := true

@export var jump_speed := 300

enum CutManState { IDLE, THROW, WALK }

var current_state: CutManState = CutManState.IDLE

@export var rolling_cutter: RollingCutter

@export var throw_distance := 48

@export var megaman: MegaMan

@onready var throw_cooldown := $ThrowCooldown

var can_throw := true
var throw := false
var walk := false

func jump():
	print("CutMan Jump!")
	velocity.y += -300


const GRAVITY := 15

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rolling_cutter.visible = false
	pass # Replace with function body.

var distance_to_megaman: float

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	if megaman:
		distance_to_megaman = self.global_position.distance_to(megaman.global_position)
		if assembled and can_throw and distance_to_megaman < throw_distance: 
			throw = true
				
	
	if not self.is_on_floor():
		velocity.y += GRAVITY
	
	move_and_slide()
	
	pass
	
func take_rolling_cutter() -> void:
	throw_cooldown.start()
	pass
	
func throw_rolling_cutter() -> void:
	assembled = false
	can_throw = false
	throw = false
	rolling_cutter.attack(megaman.global_position)


func _throw_cooldown_timeout() -> void:
	can_throw = true
	pass # Replace with function body.
