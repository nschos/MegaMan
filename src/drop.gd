class_name Drop extends CharacterBody2D

const GRAVITY := 15

enum DropType {
	EXTRA_LIFE,
	BIG_WEAPON_REFILL,
	BIG_ENERGY_REFILL,
	SMALL_WEAPON_REFILL,
	SMALL_ENERGY_REFILL,
	BONUS_PEARL,
	NOTHING
}

var drop_type_to_str: Dictionary[DropType, String] = {
	DropType.EXTRA_LIFE: "extra_life",
	DropType.BIG_WEAPON_REFILL: "big_weapon_refill",
	DropType.BIG_ENERGY_REFILL: "big_energy_refill",
	DropType.SMALL_WEAPON_REFILL: "small_weapon_refill",
	DropType.SMALL_ENERGY_REFILL: "small_energy_refill",
	DropType.BONUS_PEARL: "bonus_pearl",
	DropType.NOTHING: "nothing"
}

var drop_type: DropType

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	drop_type = get_random_drop()
	print(drop_type_to_str[drop_type])
	
	if drop_type == DropType.NOTHING:
		self.queue_free()
	
	animated_sprite.play(drop_type_to_str[drop_type])
	
	pass # Replace with function body.

func get_random_drop() -> DropType:
	var random_value := randi() % 128
	if ((0x00 <= random_value and random_value <= 0x0B) or
		(0x64 <= random_value and random_value <= 0x6F)):
		return DropType.NOTHING
	elif ((0x0C <= random_value and random_value <= 0x40) or
		  (0x70 <= random_value and random_value <= 0x7F)):
		return DropType.BONUS_PEARL
	elif (0x50 <= random_value and random_value <= 0x5E):
		return DropType.SMALL_ENERGY_REFILL
	elif (0x41 <= random_value and random_value <= 0x4F):
		return DropType.SMALL_WEAPON_REFILL
	elif (0x61 <= random_value and random_value <= 0x62):
		return DropType.BIG_ENERGY_REFILL
	elif (0x5F <= random_value and random_value <= 0x60):
		return DropType.BIG_ENERGY_REFILL
	elif (random_value == 0x63):
		return DropType.EXTRA_LIFE
	else:
		return DropType.NOTHING

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#print("teste")
	velocity.y += GRAVITY
	#print(velocity.y)
	move_and_slide()
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is MegaMan:
		self.queue_free()
	pass # Replace with function body.


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	self.queue_free()
	pass # Replace with function body.
