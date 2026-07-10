class_name Enemy extends Area2D

@export var initial_HP := 100:
	set(value):
		current_HP = value
		
var current_HP: int = initial_HP:
	get = get_health, set = set_health
	
const enemy_layer = 6

@onready var visible_notifier: VisibleOnScreenNotifier2D = VisibleOnScreenNotifier2D.new()

func _ready() -> void:
	add_child(visible_notifier)
	visible_notifier.screen_exited.connect(_despawn)
	self.set_collision_layer_value(enemy_layer, true)

func _internal_super_ready() -> void:
	print("1. CRITICAL SUPER CLASS INITIALIZATION RAN!")

func spawn() -> void:
	print("enemy spawn!")
	current_HP = initial_HP
	self.visible = true
	self.process_mode = Node.PROCESS_MODE_INHERIT

func _despawn() -> void:
	self.visible = false
	self.process_mode = Node.PROCESS_MODE_DISABLED
	despawned.emit()
	

signal died
signal despawned 

func cause_damage():
	self.current_HP -= 20

func set_health(value: int):
	var was_alive := current_HP > 0
	current_HP = max(0, value)  # Ensures health doesn't go below 0
	if current_HP == 0 and was_alive:
		ScoreManager.add_enemy_kill_score()
		died.emit()
#
func get_health() -> int:
	return current_HP
