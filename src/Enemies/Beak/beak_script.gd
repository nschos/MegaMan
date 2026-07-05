#@tool
class_name BeakEnemy extends Enemy

var frame_counter := 0

@export var flip_beak := false:
	set(value):
		flip_beak = value
		self.scale.x = 1 if not flip_beak else -1
		queue_redraw()

const closed_window    := 120
const open_1_window    := closed_window + 7
const open_2_window    := open_1_window + 7
const open_3_window    := open_2_window + 96
const shoot_1          := open_2_window
const shoot_2          := shoot_1 + 32
const shoot_3          := shoot_2 + 32
const shoot_4          := shoot_3 + 32
const closing_1_window := open_3_window + 7
const closing_2_window := closing_1_window + 7

@onready var animated_sprites = $beak_sprites

@onready var bullet_1: BeakBullet = $Bullet1
@onready var bullet_2: BeakBullet = $Bullet2
@onready var bullet_3: BeakBullet = $Bullet3
@onready var bullet_4: BeakBullet = $Bullet4

func _ready() -> void:
	super()
	print("beak _ready!")
	if not flip_beak:
		bullet_1.angle_degrees = 225
		bullet_2.angle_degrees = 188
		bullet_3.angle_degrees = 172
		bullet_4.angle_degrees = 135
	else:
		bullet_1.angle_degrees = -45
		bullet_2.angle_degrees = -8
		bullet_3.angle_degrees = 8
		bullet_4.angle_degrees = 45
	pass
	
	spawned.connect(spawn_beak)
	
	
	
func spawn_beak():
	print("spwan beak!")
	bullet_1.reparent(self, false)
	bullet_2.reparent(self, false)
	bullet_3.reparent(self, false)
	bullet_4.reparent(self, false)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	
	if Engine.is_editor_hint():
		return
	
	if frame_counter <= closed_window:
		#current_sprite = Sprite.CLOSED
		animated_sprites.play("close")
	elif frame_counter <= open_1_window:
		#current_sprite = Sprite.OPEN_1
		animated_sprites.play("open_1")
	elif frame_counter <= open_2_window:
		#current_sprite = Sprite.OPEN_2
		animated_sprites.play("open_2")
	elif frame_counter <= open_3_window:
		#current_sprite = Sprite.OPEN_3
		animated_sprites.play("open_3")
	elif frame_counter <= closing_1_window:
		#current_sprite = Sprite.OPEN_3
		animated_sprites.play("open_2")
	elif frame_counter <= closing_2_window:
		#current_sprite = Sprite.OPEN_3
		animated_sprites.play("open_1")
	else:
		frame_counter = 0
	
	
	match frame_counter:
		shoot_1:
			#bullet_1.position = Vector2.ZERO
			bullet_1.shoot()
		shoot_2:
			#bullet_2.position = Vector2.ZERO
			bullet_2.shoot()
		shoot_3:
			#bullet_3.position = Vector2.ZERO
			bullet_3.shoot()
		shoot_4:
			#bullet_4.position = Vector2.ZERO
			bullet_4.shoot()
	
	
	frame_counter += 1
	
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is MegaMan:
		#print("megaman direct impact!")
		body.take_damage(1)
	pass # Replace with function body.
