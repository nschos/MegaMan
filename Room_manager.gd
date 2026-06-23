extends Node2D

@export var player: CharacterBody2D
@export var camera: Camera2D

const ROOM_WIDTH = 256
const ROOM_HEIGHT = 256
const VIEWPORT_HEIGHT = 224
const VERTICAL_MARGIN = (ROOM_HEIGHT - VIEWPORT_HEIGHT) / 2 

var rooms_data = []
var current_room = null
var is_transitioning = false
var total_corridor_width = 0

func _ready():
	await get_tree().process_frame
	
	for child in get_children():
		var rect = _calculate_room_rect(child)
		if rect != Rect2():
			rooms_data.append({"node": child, "rect": rect})

	if player:
		_find_and_set_current_room(player.global_position, true)

func _process(_delta):
	if is_transitioning or not player or not current_room:
		return
		
	var visible_top = current_room.rect.position.y + VERTICAL_MARGIN
	var visible_bottom = current_room.rect.end.y - VERTICAL_MARGIN

	if player.global_position.y < visible_top:
		if player.state_machine.state is MegaMan_State_Climbing:
			_find_and_set_current_room(player.global_position + Vector2(0, -32), false)
			return
		
	elif player.global_position.y > visible_bottom:
		_find_and_set_current_room(player.global_position + Vector2(0, 32), false)
		return
		
	if player.global_position.x < current_room.rect.position.x or player.global_position.x > current_room.rect.end.x:
		_update_horizontal_room(player.global_position)
		if is_transitioning: return

	if total_corridor_width > 260:
		camera.global_position.x = lerp(camera.global_position.x, player.global_position.x, 0.2)
	else:
		camera.global_position.x = current_room.rect.get_center().x
		
	camera.global_position.y = current_room.rect.get_center().y

func _update_horizontal_room(target_position: Vector2):
	for room in rooms_data:
		if room.rect.has_point(target_position):
			current_room = room
			_apply_corridor_limits(current_room)
			return

func _apply_corridor_limits(target_room):
	var c_left = target_room.rect.position.x
	var c_right = target_room.rect.end.x
	var corridor_rooms = [target_room]
	var added_new = true
	
	while added_new:
		added_new = false
		for room in rooms_data:
			if room in corridor_rooms:
				continue
			for member in corridor_rooms:
				var touch_left = abs(room.rect.end.x - member.rect.position.x) < 5
				var touch_right = abs(room.rect.position.x - member.rect.end.x) < 5
				var same_height = abs(room.rect.get_center().y - member.rect.get_center().y) < 10
				
				if (touch_left or touch_right) and same_height:
					corridor_rooms.append(room)
					if room.rect.position.x < c_left: c_left = room.rect.position.x
					if room.rect.end.x > c_right: c_right = room.rect.end.x
					added_new = true
					break
			if added_new:
				break
				
	camera.limit_left = int(c_left)
	camera.limit_right = int(c_right)

	var room_center_y = target_room.rect.get_center().y
	camera.limit_top = int(room_center_y - (VIEWPORT_HEIGHT / 2))
	camera.limit_bottom = int(room_center_y + (VIEWPORT_HEIGHT / 2))
	
	total_corridor_width = c_right - c_left

func _trigger_vertical_transition(old_room, new_room):
	is_transitioning = true
	player.has_control = false
	
	if "velocity" in player:
		player.velocity = Vector2.ZERO
	
	var camera_end_x = new_room.rect.get_center().x
	var camera_end_y = new_room.rect.get_center().y
	
	camera.global_position.x = camera_end_x
	
	camera.limit_left = -10000000
	camera.limit_right = 10000000
	camera.limit_top = -10000000
	camera.limit_bottom = 10000000
	
	var dir_y = sign(camera_end_y - old_room.rect.get_center().y)
	
	var player_target_y = player.global_position.y
	if dir_y < 0:
		player_target_y = new_room.rect.end.y - 40
	else:
		player_target_y = new_room.rect.position.y + 40
	
	var tween = create_tween().set_parallel(true)
	
	#Trabalhar aqui as animações para o megaman subindo
	tween.tween_property(camera, "global_position:y", camera_end_y, 0.6).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(player, "global_position:y", player_target_y, 0.6)
	
	await tween.finished
	
	current_room = new_room
	_apply_corridor_limits(current_room)
	
	player.has_control = true
	is_transitioning = false

func _find_and_set_current_room(target_position: Vector2, immediate: bool):
	for room in rooms_data:
		if room.rect.has_point(target_position):
			var old_room = current_room
			
			if immediate:
				current_room = room
				_apply_corridor_limits(current_room)
				camera.global_position.y = current_room.rect.get_center().y
			else:
				is_transitioning = true 
				_trigger_vertical_transition(old_room, room)
			return

func _calculate_room_rect(room_node: Node) -> Rect2:
	var tilemap = _find_tilemap(room_node)
	if not tilemap:
		return Rect2()
		
	var used_rect = tilemap.get_used_rect()
	var cell_size = tilemap.tile_set.tile_size
	
	var pos = Vector2(used_rect.position) * Vector2(cell_size) + tilemap.global_position
	var size = Vector2(used_rect.size) * Vector2(cell_size)
	
	return Rect2(pos, size)

func _find_tilemap(node: Node) -> Node:
	if node is TileMap or node.is_class("TileMapLayer"):
		return node
	for child in node.get_children():
		var found = _find_tilemap(child)
		if found: 
			return found
	return null
