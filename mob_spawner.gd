#@tool
class_name MobSpawner extends Node2D

#@export var mob_path: NodePath
var mob_node: Enemy

var can_spawn := true

@onready var visible_on_screen_notifier: VisibleOnScreenNotifier2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print("mobSpawner!")
	#if not Engine.is_editor_hint():
	for child in get_children():
		if child is Enemy:
	#if not mob_path.is_empty():
		#var node = get_node(mob_path)
		#if node is Enemy:
			mob_node = child
			mob_node.visible = false
			mob_node.process_mode = Node.PROCESS_MODE_DISABLED
			
			mob_node.died.connect(_enemy_died)
			mob_node.despawned.connect(func(): can_spawn = true)
			
	assert(mob_node != null, "MobSpawner is missing a Enemy child!")
		
	visible_on_screen_notifier = VisibleOnScreenNotifier2D.new()
	visible_on_screen_notifier.rect = Rect2()
	visible_on_screen_notifier.screen_entered.connect(_spawn_enemy)
	add_child(visible_on_screen_notifier)
	
	
	#var mob_spawner_sprite = Sprite2D.new()
	#add_child(mob_spawner_sprite)
	
	pass # Replace with function body.

		
func _enemy_died() -> void:
	
	SFXManager.play(SFXManager.EXPLOSION)
	#print("enemy died")
	mob_node.process_mode = Node.PROCESS_MODE_DISABLED
	mob_node.visible = false
	can_spawn = true
	pass

func _spawn_enemy() -> void:
	if can_spawn:
		#mob_node.visible = true
		#mob_node.process_mode = Node.PROCESS_MODE_INHERIT
		can_spawn = false
		mob_node.spawn()
		pass
