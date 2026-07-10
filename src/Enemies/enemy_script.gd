@icon("uid://kbphqhfa66bp")
class_name Enemy extends Area2D

@export var initial_HP := 100:
	set(value):
		current_HP = value
		
var current_HP: int = initial_HP:
	get = get_health, set = set_health
	
const enemy_layer = 6

const drop_scene := preload("res://Drops/drop.tscn")
const death_scene := preload("res://enemy_death_scene.tscn")

@onready var visible_notifier: VisibleOnScreenNotifier2D = VisibleOnScreenNotifier2D.new()

func _ready() -> void:
	#print("enemy _ready!")
	add_child(visible_notifier)
	visible_notifier.screen_exited.connect(_despawn)
	self.set_collision_layer_value(enemy_layer, true)

func spawn() -> void:
	_reset()
	#print("enemy spawn!")
	current_HP = initial_HP
	self.visible = true
	self.process_mode = Node.PROCESS_MODE_INHERIT
	spawned.emit()

func _despawn() -> void:
	#print("enemy despawned!")
	self.visible = false
	self.process_mode = Node.PROCESS_MODE_DISABLED
	despawned.emit()
	
func _reset() -> void:
	pass

signal died
signal despawned
signal spawned

func cause_damage():
	self.current_HP -= 20

func spawn_drop() -> void:
	var drop := drop_scene.instantiate()
	get_tree().current_scene.add_child.call_deferred(drop)
	drop.position = self.global_position
	pass

func set_health(value: int):
	var was_alive := current_HP > 0
	current_HP = max(0, value)
	if current_HP == 0 and was_alive:
		spawn_drop()
		explosion_animation()
		ScoreManager.add_enemy_kill_score()
		died.emit()

func explosion_animation() -> void:
	var explosion: Node2D = death_scene.instantiate()
	get_tree().current_scene.add_child(explosion)
	explosion.position = self.global_position

func get_health() -> int:
	return current_HP
