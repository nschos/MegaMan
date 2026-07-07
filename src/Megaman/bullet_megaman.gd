class_name MegamanBullet extends Area2D

var current_direction: MegaMan.Direction = MegaMan.Direction.RIGHT
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

func shoot(direction: MegaMan.Direction):
	bullet_moving = true
	visible = true
	#print(self.get_path())
	#if self.get_path() == NodePath("/root/MainNode/BulletMegaman1"):
		#print("node process mode inherited!")
	current_direction = direction
	pass


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	bullet_moving = false
	#self.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
	#if self.get_path() == NodePath("/root/MainNode/BulletMegaman1"):
		#print("node process mode disabeld!")
	self.visible = false
	pass # Replace with function body.
	



func _on_body_entered(_body: Node2D) -> void:
	print("shoot!")
	pass # Replace with function body.


func _on_area_entered(area: Area2D) -> void:
	if area is Enemy:
		#print("damage!")
		area.cause_damage()
		self._on_visible_on_screen_notifier_2d_screen_exited()
	pass # Replace with function body.
