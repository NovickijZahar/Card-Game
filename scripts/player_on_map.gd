extends Node2D

var astar_grid: AStarGrid2D
@onready var tile_map = $"../TileMap"
@onready var enter_button = $Camera2D/EnterButton
var current_id_path: Array[Vector2i]
var target_position: Vector2
var is_moving: bool
var speed: int = 800
var current_pos: Vector2
var current_loc = Locations.None

var flag = true

enum Locations
{
	None,
	Enemy,
	Treasure,
	Shop
}


func _ready():
	global_position = Global.map_position
	for pos in Global.completed_events:
		tile_map.set_cell(0, pos, 2, Vector2i(1, 1))
	for pos in Global.uncompleted_events.keys():
		tile_map.set_cell(0, pos, 2, Global.uncompleted_events[pos])
	
	astar_grid = AStarGrid2D.new()
	astar_grid.region = tile_map.get_used_rect()
	astar_grid.cell_size = Vector2(32, 32)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
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

func _process(delta):
	$Camera2D/GridContainer/Label2.text = str(Global.money) + '$'

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
				if tile_map.get_cell_tile_data(0, current_pos)!= null and tile_map.get_cell_tile_data(0, current_pos).get_custom_data("event") != 0:
					enter_button.visible = true
					enter_button.text = "Войти"
					current_loc = tile_map.get_cell_tile_data(0, current_pos).get_custom_data("event")



func _on_deck_edit_button_down():
	flag = false
	Global.map_position = global_position
	get_tree().change_scene_to_file("res://scenes/deck_edit.tscn")


func _on_load_button_button_down():
	flag = false
	Global.load_data()
	global_position = Global.map_position
	for pos in Global.completed_events:
		tile_map.set_cell(0, pos, 2, Vector2i(1, 1))
	for pos in Global.uncompleted_events.keys():
		tile_map.set_cell(0, pos, 2, Global.uncompleted_events[pos])
	current_id_path.clear()
	enter_button.visible = false
	flag = true


func _on_save_button_button_down():
	flag = false
	Global.map_position = global_position
	for x in tile_map.get_used_rect().size.x:
		for y in tile_map.get_used_rect().size.y:
			var tile_position = Vector2i(
				x + tile_map.get_used_rect().position.x,
				y + tile_map.get_used_rect().position.y
			)
			if tile_map.get_cell_tile_data(0, tile_position)!= null and tile_map.get_cell_tile_data(0, tile_position).get_custom_data("event") != 0:
				Global.uncompleted_events[tile_position] =  tile_map.get_cell_atlas_coords(0, tile_position)
	current_id_path.clear()
	Global.save_data()
	flag = true


func _on_enter_button_button_down():
	flag = false
	Global.map_position = global_position
	match current_loc:
		Locations.Treasure:
			get_tree().change_scene_to_file("res://scenes/treasure.tscn")
			Global.completed_events.append(current_pos)
			Global.uncompleted_events.erase(Vector2i(current_pos))
		Locations.Enemy:
			get_tree().change_scene_to_file("res://scenes/play_space.tscn")
			Global.completed_events.append(current_pos)
			Global.uncompleted_events.erase(Vector2i(current_pos))
		Locations.Shop:
			get_tree().change_scene_to_file("res://scenes/shop.tscn")
