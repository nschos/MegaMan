class_name OctopusBatteryEnemy extends Enemy

@export var speed: float = 70.0
@export var damage_amount: int = 4
@export var pause_time: float = 1.0 

@onready var target_marker: Marker2D = $TargetMarker
@onready var sprite: AnimatedSprite2D = $inimigo5

var spawn_position: Vector2
var start_point: Vector2
var end_point: Vector2
var current_target: Vector2
var moving_to_end: bool = true

var is_paused: bool = false
var is_waking_up: bool = false 
var current_pause_timer: float = 0.0

func _ready() -> void:
	super() 
	initial_HP = 2 
	
	spawn_position = global_position
	start_point = spawn_position
	
	var target_offset = target_marker.position
	
	end_point = spawn_position + target_offset
	current_target = end_point
	
	target_marker.visible = false
	
	body_entered.connect(_on_body_entered)
	
	
	if sprite:
		sprite.animation_finished.connect(_on_animation_finished)

func _reset() -> void:
	global_position = spawn_position
	current_target = end_point
	moving_to_end = true
	
	is_paused = false
	is_waking_up = false
	current_pause_timer = 0.0
	
	if sprite:
		sprite.play("moving") 

func _physics_process(delta: float) -> void:
	if is_waking_up:
		return
		
	if is_paused:
		current_pause_timer += delta 
		
		if current_pause_timer >= pause_time:
			is_paused = false
			is_waking_up = true
			current_pause_timer = 0.0
			
			if moving_to_end:
				current_target = start_point
				moving_to_end = false
			else:
				current_target = end_point
				moving_to_end = true

			_update_sprite_direction(target_marker.position)
			
			if sprite:
				sprite.play("move_anim")
				
		return 
		
	global_position = global_position.move_toward(current_target, speed * delta)
	
	if global_position.distance_to(current_target) < 0.5:
		is_paused = true
		if sprite:
			sprite.play("move_stop") 

func _update_sprite_direction(offset: Vector2) -> void:
	if sprite and offset.x != 0:
		var dir_x = (current_target.x - global_position.x)
		if dir_x > 0:
			sprite.flip_h = true
		elif dir_x < 0:
			sprite.flip_h = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.has_method("take_damage"):
		body.take_damage(damage_amount)

func _on_animation_finished() -> void:
	if sprite.animation == "move_anim":
		is_waking_up = false
		sprite.play("moving")
