extends Node2D

@export var player: CharacterBody2D
@export var camera: Camera2D

const ROOM_WIDTH := 256
const ROOM_HEIGHT := 256
const VIEWPORT_HEIGHT := 224
const VERTICAL_MARGIN: int = int((ROOM_HEIGHT - VIEWPORT_HEIGHT) / 2.0)

var rooms_dict: Dictionary[Node, Rect2] = {}
var current_room: Node2D = null
var is_transitioning := false

func _ready():
	await get_tree().process_frame
	
	for child in get_children():
		var rect = _calculate_room_rect(child)
		if rect != Rect2():
			rooms_dict[child] = rect

	if player:
		_find_and_set_current_room(player.global_position, true)

func _process(_delta):
	if is_transitioning or not player or not current_room:
		return
		
	var visible_top = rooms_dict[current_room].position.y + VERTICAL_MARGIN
	var visible_bottom = rooms_dict[current_room].end.y - VERTICAL_MARGIN

	if player.global_position.y < visible_top:
		if player.state_machine.state is MegaMan_State_Climbing:
			_find_and_set_current_room(player.global_position + Vector2(0, -32), false)
			return
		
	elif player.global_position.y > visible_bottom:
		_find_and_set_current_room(player.global_position + Vector2(0, 32), false)
		return
		
	#if player.global_position.x < rooms_dict[current_room].position.x or player.global_position.x > rooms_dict[current_room].end.x:
		#_update_horizontal_room(player.global_position)
		#if is_transitioning: return

	camera.global_position = player.global_position
	camera.global_position.y = rooms_dict[current_room].get_center().y

func walk_animation() -> void:
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(player, "global_position:x", player.global_position.x+64, 2.0)
	tween.tween_property(camera, "offset:x", 256, 2.0)
	
	await tween.finished
	
	camera.offset.x = 0
	
	_find_and_set_current_room()
	
	pass

func _update_horizontal_room(target_position: Vector2):
	for room in rooms_dict:
		if rooms_dict[room].has_point(target_position):
			current_room = room
			_apply_corridor_limits(current_room)
			return

func _apply_corridor_limits(target_room):
	var rect := rooms_dict[target_room]
	camera.limit_left   = int(rect.position.x)
	camera.limit_right  = int(rect.position.x + rect.size.x)
	camera.limit_top    = int(rect.position.y)
	camera.limit_bottom = int(rect.position.y + rect.size.y)
	camera.offset.x = 0

func _trigger_vertical_transition(old_room, new_room):
	is_transitioning = true
	player.has_control = false
	
	if "velocity" in player:
		player.velocity = Vector2.ZERO
	
	var camera_end_y = rooms_dict[new_room].get_center().y
	
	var dir_y = sign(camera_end_y - rooms_dict[old_room].get_center().y)
	
	var player_target_y = player.global_position.y
	if dir_y < 0:
		player_target_y = rooms_dict[new_room].end.y - 40
	else:
		player_target_y = rooms_dict[new_room].position.y + 40
	
	var tween = create_tween().set_parallel(true)
	
	var cameraOffset: float = 248 if dir_y > 0 else -264
	
	tween.tween_property(camera, "offset:y", cameraOffset, 0.6)
	tween.tween_property(player, "global_position:y", player_target_y, 0.6)
	
	await tween.finished
	
	camera.offset.y = -8
	camera.global_position.y = camera_end_y
	
	current_room = new_room
	_apply_corridor_limits(current_room)
	
	player.has_control = true
	is_transitioning = false

func _find_and_set_current_room(target_position: Vector2 = player.global_position, immediate: bool = true):
	for room in rooms_dict:
		if rooms_dict[room].has_point(target_position):
			var old_room = current_room
			
			if immediate:
				current_room = room
				_apply_corridor_limits(current_room)
				camera.global_position.y = rooms_dict[current_room].get_center().y
			else:
				is_transitioning = true 
				_trigger_vertical_transition(old_room, room)
			return

func _calculate_room_rect(room_node: Node) -> Rect2:
	var room_position = room_node.global_position
	if room_node is HorizontalRoomScroll:
		var number_of_rooms := 0
		for node in room_node.get_children():
			if node is Room:
				number_of_rooms += 1
		var room_size = Vector2(number_of_rooms * 256, 256)
		return Rect2(room_position, room_size)
	else:
		return Rect2(room_position, Vector2(256, 256))
