class_name BeakBullet extends Area2D

var angle_degrees := 0
var is_moving := false
var direction := Vector2.ZERO

const bullet_speed = 169.73125884

var beak_parent: BeakEnemy

@onready var visible_on_screen_notifier := $VisibleOnScreenNotifier2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_parent() is BeakEnemy:
		beak_parent = get_parent()
		
	pass # Replace with function body.


func shoot() -> void:
	self.position = Vector2.ZERO
	self.reparent(get_tree().current_scene)
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
	if beak_parent:
		self.reparent(beak_parent)
	pass # Replace with function body.


func _on_body_entered(body: Node2D) -> void:
	if body is MegaMan:
		body.take_damage(1)
	pass # Replace with function body.
