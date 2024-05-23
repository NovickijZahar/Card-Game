extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_button_pressed():
	var database = SQLite.new()
	database.path = 'res://data.db'
	database.open_db()
	var card_table = {
		"id": {"data_type":"int", "primary_key": true, "not_null": true, "auto_increment": true},
		"name": {"data_type": "text"},
		"description": {"data_type": "text", "default": "[]"},
		"image_name": {"data_type": "text"},
		"rarity": {"data_type": "int"},
		"manacost": {"data_type": "int"},
		"attack": {"data_type": "int"},
		"hp": {"data_type": "int"},
		"in_deck": {"data_type": "bool", "default": false},
		"in_collection": {"data_type": "bool", "default": false},
	}
	database.drop_table("CardDataBase")
	database.create_table("CardDataBase", card_table)
	database.insert_rows("CardDataBase", 
		[arr_to_dict(['Killer', 'Killer.png', AbstractCard.Rarity.Common, 2, 5, 1, [1]]),
		arr_to_dict(['Warrior', 'Warrior.png', AbstractCard.Rarity.Rare, 2, 3, 4]),
		arr_to_dict(['Spirit', 'Spirit.webp', AbstractCard.Rarity.Epic, 5, 7, 7]),
		arr_to_dict(['Shadow', 'ShadowWarrior.png', AbstractCard.Rarity.Rare, 6, 6, 6]),
		arr_to_dict(['Dragon', 'Dragon.webp', AbstractCard.Rarity.Legendary, 8, 10, 10]),
		arr_to_dict(['Baby dragon', 'DragonBaby.webp', AbstractCard.Rarity.Common, 1, 1, 2]),
		arr_to_dict(['Druid', 'Druid.webp', AbstractCard.Rarity.Rare, 2, 3, 2]),
		arr_to_dict(['Lion', 'Lion.webp', AbstractCard.Rarity.Rare, 4, 4, 4]),
		arr_to_dict(['Owl', 'Owl.webp', AbstractCard.Rarity.Common, 1, 2, 1]),
		arr_to_dict(['Demon', 'DemonKnight.webp', AbstractCard.Rarity.Epic, 3, 4, 3])])
	
	database.update_rows("CardDataBase", 
		"id==1 or id==2 or id==3 or id==4 or id==5 or id==6", 
		{"in_deck": true, "in_collection": true})
	
	
	var player_table = {
		"id": {"data_type": "int", "primary_key": true, "not_null": true, "auto_increment": true},
		"money": {"data_type": "int"},
		"experience": {"data_type": "int"},
		"map_position_x": {"data_type": "real", "default": 0.0},
		"map_position_y": {"data_type": "real", "default": 0.0},
		"completed_events": {"data_type": "text", "default": "[]"}
	}
	database.drop_table("Player")
	database.create_table("Player", player_table)
	database.insert_row("Player", {"money": 200, "experience": 20, "completed_events": "[]"})
	
	
	var hero_table = {
		"id": {"data_type": "int", "primary_key": true, "not_null": true, "auto_increment": true},
		"name": {"data_type": "text"},
		"image_name":  {"data_type": "text"},
		"deck": {"data_type": "text", "default": "[]"},
		"hp": {"data_type": "int", "default": 30}
	}
	database.drop_table("Heroes")
	database.create_table("Heroes", hero_table)
	database.insert_rows("Heroes", 
	[{"name":"Поврежденный рыцарь", "image_name": "Hero.webp", "deck": "[]"},
	{"name":"Странник", "image_name": "Stranger.webp", "deck": "[5,6,7,8,9,10]"}])
	
	var feature_table = {
		"id": {"data_type": "int", "primary_key": true, "not_null": true, "auto_increment": true},
		"name": {"data_type": "text"},
		"description": {"data_type": "text"},
		"type": {"data_type": "text"}
	}
	database.drop_table("Features")
	database.create_table("Features", feature_table)
	database.insert_rows("Features", 
	[{"name": "Цепная атака", "description": "Наносит урон карте противника и карте за ней", "type": "При атаке"},
	{"name": "Ближний шквал", "description": "Наносит X урона всем существам противника на ближней линии", "type": "При атаке"},
	{"name": "Дальний шквал", "description": "Наносит X урона всем существам противника на дальней линии", "type": "При атаке"},
	{"name": "Шквал", "description": "Наносит X урона всем существам противника", "type": "При атаке"},
	{"name": "Разогрев", "description": "После атаки получает +X к атаке и +Y к здоровью", "type": "При атаке"},
	{"name": "Восстановление", "description": "Восстанавливает X здоровья всем союзным картам", "type": "При атаке"},
	{"name": "Яд", "description": "Уничтожает карту, которой наносит урон", "type": "При атаке"},
	{"name": "Отражение", "description": "Возвращает урон карте, которая нанесла урон этой карте", "type": "При получении урона"},
	{"name": "Ближняя колючесть", "description": "Наносит X урона всем существам противника на ближней линии", "type": "При получении урона"},
	{"name": "Дальняя колючесть", "description": "Наносит X урона всем существам противника на дальней линии", "type": "При получении урона"},
	{"name": "Колючесть", "description": "Наносит X урона всем существам противника", "type": "При получении урона"},
	{"name": "Перенаправление", "description": "Возвращает урон базе противника", "type": "При получении урона"},])
	
	get_tree().change_scene_to_file("res://scenes/map.tscn")
	

func arr_to_dict(arr: Array) -> Dictionary:
	var res = {"name": arr[0], "image_name": arr[1], 
				"rarity": arr[2], "manacost": arr[3], 
				"attack": arr[4], "hp": arr[5]}
	if arr.size() == 6:
		res["description"] = "[]"
	else:
		res["description"] = str(arr[6])
	return res

func _on_exit_button_pressed():
	get_tree().quit()


func _on_continue_button_pressed():
	get_tree().change_scene_to_file("res://scenes/map.tscn")
