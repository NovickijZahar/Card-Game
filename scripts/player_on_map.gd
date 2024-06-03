extends Node2D

var astar_grid: AStarGrid2D
var tile_map
@onready var tile_map1 = $"../TileMap1"
@onready var tile_map2 = $"../TileMap2"
@onready var tile_map3 = $"../TileMap3"
@onready var tile_map4 = $"../TileMap4"
@onready var tile_map5 = $"../TileMap5"
@onready var enter_button = $Camera2D/EnterButton
var current_id_path: Array[Vector2i]
var target_position: Vector2
var is_moving: bool
var speed: int = 1000
var current_pos: Vector2
var current_loc = Locations.None
var current_room = 1
var current_boss = 0

var flag = true

enum Locations
{
	None,
	Enemy,
	Treasure,
	Shop
}

enum State
{
	None,
	Location,
	Room,
	Boss
}

var current_state = State.None



func _ready():
	match DatabaseService.get_current_room():
		1: tile_map = tile_map1
		2: tile_map = tile_map2
		3: tile_map = tile_map3
		4: tile_map = tile_map4
		5: tile_map = tile_map5
	tile_map.visible = true
	$Camera2D/GridContainer/Label2.text = str(DatabaseService.get_money()) + '$'
	global_position = DatabaseService.get_map_position()
	for pos in DatabaseService.get_completed_events():
		tile_map.set_cell(0, Vector2(pos[0], pos[1]), 2, Vector2i(1, 1))
	
	astar_grid = AStarGrid2D.new()
	astar_grid.region = tile_map.get_used_rect()
	astar_grid.cell_size = Vector2(32, 32)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ALWAYS
	astar_grid.update()
	for x in tile_map.get_used_rect().size.x:
		for y in tile_map.get_used_rect().size.y:
			var tile_position = Vector2i(
				x + tile_map.get_used_rect().position.x,
				y + tile_map.get_used_rect().position.y
			)
			var tile_data = tile_map.get_cell_tile_data(0, tile_position)
			if tile_data == null or !tile_data.get_custom_data("walkable"):
				astar_grid.set_point_solid(tile_position)
	
func _input(event):
	if event.is_action_pressed("move") == false and flag:
		return
	
	
	var id_path
	if is_moving:
		id_path = astar_grid.get_id_path(
			tile_map.local_to_map(target_position),
			tile_map.local_to_map(get_global_mouse_position())
		)
	else:
		id_path = astar_grid.get_id_path(
			tile_map.local_to_map(global_position),
			tile_map.local_to_map(get_global_mouse_position())
		).slice(1)
	
	if !id_path.is_empty():
		current_id_path = id_path

func _physics_process(delta):
	if flag:
		if current_id_path.is_empty():
			return
		if !is_moving:
			target_position = tile_map.map_to_local(current_id_path.front())
			is_moving = true
			
		global_position = global_position.move_toward(target_position, speed * delta)
		
		if global_position == target_position:
			current_pos = current_id_path.pop_front()
			enter_button.visible = false
			if !current_id_path.is_empty():
				target_position = tile_map.map_to_local(current_id_path.front())
			else:
				is_moving = false
				if tile_map.get_cell_tile_data(0, current_pos)!= null:
					if tile_map.get_cell_tile_data(0, current_pos).get_custom_data("event") != 0:
						enter_button.visible = true
						enter_button.text = "Войти"
						current_loc = tile_map.get_cell_tile_data(0, current_pos).get_custom_data("event")
						current_state = State.Location
					elif tile_map.get_cell_tile_data(0, current_pos).get_custom_data("location") != 0:
						enter_button.visible = true
						enter_button.text = "Перейти в следующую локацию"
						current_room = tile_map.get_cell_tile_data(0, current_pos).get_custom_data("location")
						current_state = State.Room
					elif tile_map.get_cell_tile_data(0, current_pos).get_custom_data("boss") != 0:
						enter_button.visible = true
						enter_button.text = "Сразиться с боссом"
						current_boss = tile_map.get_cell_tile_data(0, current_pos).get_custom_data("boss")
						current_state = State.Boss


func _on_deck_edit_button_down():
	flag = false
	DatabaseService.set_map_position(global_position)
	get_tree().change_scene_to_file("res://scenes/deck_edit.tscn")



func _on_enter_button_button_down():
	flag = false
	if current_state == State.Location:
		DatabaseService.set_map_position(global_position)
		match current_loc:
			Locations.Treasure:
				get_tree().change_scene_to_file("res://scenes/treasure.tscn")
				DatabaseService.add_completed_event(current_pos)
			Locations.Enemy:
				get_tree().change_scene_to_file("res://scenes/play_space.tscn")
				DatabaseService.add_completed_event(current_pos)
			Locations.Shop:
				get_tree().change_scene_to_file("res://scenes/shop.tscn")
	elif current_state == State.Room:
		var res = get_all_battles()
		if res == 0:
			DatabaseService.change_room(current_room)
			DatabaseService.clear_completed_events()
			get_tree().reload_current_scene()
			tile_map.visible = false
			DatabaseService.set_map_position(Vector2(0, 0))
		else:
			$"../Popup/CenterContainer/Label".text = 'Для перехода в следующую локацию вы должны победить всех противников на этой локации\n(Осталось ' + str(res) + ')'
			$"../Popup".popup(Rect2i(500, 300, 920, 460))
	elif current_state == State.Boss:
		var res = get_all_battles()
		if res == 0:
			get_tree().change_scene_to_file("res://scenes/play_space.tscn")
			DatabaseService.set_current_boss(current_boss)
			DatabaseService.clear_completed_events()
			DatabaseService.set_map_position(Vector2(0, 0))
			tile_map.visible = false
		else:
			$"../Popup/CenterContainer/Label".text = 'Для сражения с боссом вы должны победить всех противников на этой локации\n(Осталось ' + str(res) + ')'
			$"../Popup".popup(Rect2i(500, 300, 920, 460))

func get_all_battles():
	var res = 0
	for x in tile_map.get_used_rect().size.x:
		for y in tile_map.get_used_rect().size.y:
			var tile_position = Vector2i(
				x + tile_map.get_used_rect().position.x,
				y + tile_map.get_used_rect().position.y
			)
			var tile_data = tile_map.get_cell_tile_data(0, tile_position)
			if tile_data != null and tile_data.get_custom_data("event") == Locations.Enemy:
				res += 1
	return res


func _on_menu_button_button_down():
	get_tree().change_scene_to_file("res://scenes/node_2d.tscn")


func _on_popup_popup_hide():
	flag = true
