class_name CutMan extends CharacterBody2D

@export var assembled := true

@export var jump_speed := 300

enum CutManState { IDLE, THROW }

var current_state: CutManState = CutManState.IDLE

@export var rolling_cutter: RollingCutter

@export var throw_distance := 48

@export var megaman: MegaMan

func jump():
	print("CutMan Jump!")
	velocity.y += -300


const GRAVITY := 15

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rolling_cutter.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	if megaman:
		if assembled: 
			var distance := self.global_position.distance_to(megaman.global_position)
			if distance < throw_distance:
				throw_rolling_cutter()
				
	
	
	velocity.y += GRAVITY
	
	move_and_slide()
	
	pass
	
func throw_rolling_cutter() -> void:
	assembled = false
	rolling_cutter.attack(megaman.global_position)


func _on_timer_timeout() -> void:
	jump()
	pass # Replace with function body.
