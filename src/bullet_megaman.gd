class_name MegamanBullet extends Area2D

enum Direction { LEFT = -1, RIGHT = 1 }

var current_direction: Direction
var bullet_moving := false

const bullet_velocity := 240

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if bullet_moving:
		self.position.x += delta * bullet_velocity * current_direction
	pass

func shoot(direction: Direction):
	bullet_moving = true
	visible = true
	process_mode = Node.PROCESS_MODE_INHERIT
	current_direction = direction
	pass


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	bullet_moving = false
	self.process_mode = Node.PROCESS_MODE_DISABLED
	self.visible = false
	pass # Replace with function body.
