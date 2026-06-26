class_name Enemy extends Area2D

@export var initial_HP := 100:
	set(value):
		current_HP = value
		
var current_HP: int = initial_HP:
	get = get_health, set = set_health

@onready var visible_notifier: VisibleOnScreenNotifier2D = VisibleOnScreenNotifier2D.new()

func _ready() -> void:
	add_child(visible_notifier)
	visible_notifier.screen_exited.connect(_despawn)

func _internal_super_ready() -> void:
	print("1. CRITICAL SUPER CLASS INITIALIZATION RAN!")

func spawn() -> void:
	print("enemy spawn!")
	self.visible = true
	self.process_mode = Node.PROCESS_MODE_INHERIT

func _despawn() -> void:
	self.visible = false
	self.process_mode = Node.PROCESS_MODE_DISABLED
	despawned.emit()
	

signal died
signal despawned 

func set_health(value: int):
	current_HP = max(0, value)  # Ensures health doesn't go below 0
	if current_HP == 0:
		died.emit()
#
func get_health() -> int:
	return current_HP
