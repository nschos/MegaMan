class_name SuperCutterEnemy extends Enemy

@export var jump_force: float = -400.0  
@export var fall_gravity: float = 900.0 
@export var horizontal_speed: float = 150.0
@export var direction: float = -1.0   

var velocity: Vector2 = Vector2.ZERO

@onready var sprite: AnimatedSprite2D = $inimigo3 

func _ready() -> void:
	super() 
	
	initial_HP = 5 
	
	_reset()

func _reset() -> void:
	velocity.y = jump_force
	velocity.x = horizontal_speed * direction
	

func _physics_process(delta: float) -> void:
	velocity.y += fall_gravity * delta
	
	position += velocity * delta

func _on_body_entered(body: Node2D) -> void:
	if body is MegaMan:
		body.take_damage(4)
