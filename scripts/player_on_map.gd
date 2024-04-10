extends Node2D

var astar_grid: AStarGrid2D
@onready var tile_map = $"../TileMap"
var current_id_path: Array[Vector2i]
var target_position: Vector2
var is_moving: bool
var speed: int = 800

func _ready():
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
	if event.is_action_pressed("move") == false:
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
	if current_id_path.is_empty():
		return
	if !is_moving:
		target_position = tile_map.map_to_local(current_id_path.front())
		is_moving = true
	
	global_position = global_position.move_toward(target_position, speed * delta)
	
	if global_position == target_position:
		current_id_path.pop_front()
		
		if !current_id_path.is_empty():
			target_position = tile_map.map_to_local(current_id_path.front())
		else:
			is_moving = false
