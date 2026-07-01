class_name BeakBullet extends Area2D

@export var angle_degrees := 225 
var is_moving := false
var direction := Vector2.ZERO

const bullet_speed = 169.73125884

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func shoot() -> void:
	self.visible = true
	var rad = deg_to_rad(angle_degrees)
	direction = Vector2(cos(rad), sin(rad))
	is_moving = true
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_moving:
		self.position += direction * delta * bullet_speed
	pass


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	is_moving = false
	visible = false
	pass # Replace with function body.


func _on_body_entered(body: Node2D) -> void:
	if body is MegaMan:
		body.take_damage(1)
	pass # Replace with function body.
