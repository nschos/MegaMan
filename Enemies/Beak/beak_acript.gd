extends Enemy

var frame_counter := 0

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

@onready var bullet_1 = $Bullet1
@onready var bullet_2 = $Bullet2
@onready var bullet_3 = $Bullet3
@onready var bullet_4 = $Bullet4

#enum Sprite { CLOSED, OPEN_1, OPEN_2, OPEN_3 }
#
#var current_sprite: Sprite = Sprite.CLOSED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	
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
		print(frame_counter)
		frame_counter = 0
	
	
	match frame_counter:
		shoot_1:
			bullet_1.position = Vector2.ZERO
			bullet_1.shoot()
		shoot_2:
			bullet_2.position = Vector2.ZERO
			bullet_2.shoot()
		shoot_3:
			bullet_3.position = Vector2.ZERO
			bullet_3.shoot()
		shoot_4:
			bullet_4.position = Vector2.ZERO
			bullet_4.shoot()
	
	
	frame_counter += 1
	
	pass
	
func shoot(bullet: Area2D) -> void:
	if bullet is BeakBullet:
		bullet.angle_degrees = 225
		bullet.shoot()
	#var tween = get_tree().create_tween()
	#tween.tween_property(bullet, "position", self.position + Vector2(-500, 0), 1)
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is MegaMan:
		#print("megaman direct impact!")
		body.take_damage(1)
	pass # Replace with function body.
