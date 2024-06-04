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
		"id": {"data_type":"int", "primary_key": true, 
		"not_null": true, "auto_increment": true},
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
		[arr_to_dict(['Убийца', 'Killer.png', AbstractCard.Rarity.Common, 2, 5, 1]),
		arr_to_dict(['Воин', 'Warrior.png', AbstractCard.Rarity.Rare, 2, 3, 4]),
		arr_to_dict(['Дух', 'Spirit.webp', AbstractCard.Rarity.Epic, 5, 7, 7]),
		arr_to_dict(['Тень', 'ShadowWarrior.png', AbstractCard.Rarity.Rare, 6, 6, 6]),
		arr_to_dict(['Дракон', 'Dragon.webp', AbstractCard.Rarity.Legendary, 8, 10, 10]),
		arr_to_dict(['Дракончик', 'DragonBaby.webp', AbstractCard.Rarity.Common, 1, 1, 2]),
		arr_to_dict(['Друид', 'Druid.webp', AbstractCard.Rarity.Rare, 2, 3, 2]),
		arr_to_dict(['Лев', 'Lion.webp', AbstractCard.Rarity.Rare, 4, 4, 4]),
		arr_to_dict(['Сова', 'Owl.webp', AbstractCard.Rarity.Common, 1, 2, 1]),
		arr_to_dict(['Демон', 'DemonKnight.webp', AbstractCard.Rarity.Epic, 3, 4, 3]),
		arr_to_dict(['Вестники', 'DeathServants.png', AbstractCard.Rarity.Epic, 4, 5, 4]),
		arr_to_dict(['Слуга льда', 'IceServant.png', AbstractCard.Rarity.Epic, 2, 3, 3]),
		arr_to_dict(['Слуга снега', 'SnowServant.png', AbstractCard.Rarity.Epic, 5, 6, 5]),
		arr_to_dict(['Застывший', 'SnowCommander.png', AbstractCard.Rarity.Epic, 7, 8, 8]),
		arr_to_dict(['Лошадь', 'Horse.webp', AbstractCard.Rarity.Epic, 3, 1, 4])])
	
	database.update_rows("CardDataBase", 
		"id==1 or id==2 or id==3 or id==4 or id==5 or id==6", 
		{"in_deck": true, "in_collection": true})
	
	var enemy_card_table = {
		"id": {"data_type":"int", "primary_key": true, 
		"not_null": true, "auto_increment": true},
		"name": {"data_type": "text"},
		"description": {"data_type": "text", "default": "[]"},
		"image_name": {"data_type": "text"},
		"rarity": {"data_type": "int"},
		"manacost": {"data_type": "int"},
		"attack": {"data_type": "int"},
		"hp": {"data_type": "int"},
	}
	database.drop_table("EnemyCardDataBase")
	database.create_table("EnemyCardDataBase", card_table)
	database.insert_rows("EnemyCardDataBase", 
		[arr_to_dict(['Убийца', 'Killer.png', AbstractCard.Rarity.Common, 2, 5, 1]),
		arr_to_dict(['Воин', 'Warrior.png', AbstractCard.Rarity.Rare, 2, 3, 4]),
		arr_to_dict(['Дух', 'Spirit.webp', AbstractCard.Rarity.Epic, 5, 7, 7]),
		arr_to_dict(['Тень', 'ShadowWarrior.png', AbstractCard.Rarity.Rare, 6, 6, 6]),
		arr_to_dict(['Дракон', 'Dragon.webp', AbstractCard.Rarity.Legendary, 8, 10, 10]),
		arr_to_dict(['Дракончик', 'DragonBaby.webp', AbstractCard.Rarity.Common, 1, 1, 2]),
		arr_to_dict(['Друид', 'Druid.webp', AbstractCard.Rarity.Rare, 2, 3, 2]),
		arr_to_dict(['Лев', 'Lion.webp', AbstractCard.Rarity.Rare, 4, 4, 4]),
		arr_to_dict(['Сова', 'Owl.webp', AbstractCard.Rarity.Common, 1, 2, 1]),
		arr_to_dict(['Демон', 'DemonKnight.webp', AbstractCard.Rarity.Epic, 3, 4, 3]),
		arr_to_dict(['Вестники', 'DeathServants.png', AbstractCard.Rarity.Epic, 4, 5, 4]),
		arr_to_dict(['Слуга льда', 'IceServant.png', AbstractCard.Rarity.Epic, 2, 3, 3]),
		arr_to_dict(['Слуга снега', 'SnowServant.png', AbstractCard.Rarity.Epic, 5, 6, 5]),
		arr_to_dict(['Застывший', 'SnowCommander.png', AbstractCard.Rarity.Epic, 7, 8, 8]),
		arr_to_dict(['Лошадь', 'Horse.webp', AbstractCard.Rarity.Epic, 3, 1, 4])])
	database.update_rows("EnemyCardDataBase", "id==10", {"description": "[1]"})
	database.update_rows("EnemyCardDataBase", "id==11", {"description": "[2]"})
	database.update_rows("EnemyCardDataBase", "id==12", {"description": "[3]"})
	database.update_rows("EnemyCardDataBase", "id==13", {"description": "[4]"})
	database.update_rows("EnemyCardDataBase", "id==14", {"description": "[5]"})
	database.update_rows("EnemyCardDataBase", "id==15", {"description": "[1,2]"})
	database.update_rows("EnemyCardDataBase", "id==16", {"description": "[1,5]"})
	
	var player_table = {
		"id": {"data_type": "int", "primary_key": true, 
		"not_null": true, "auto_increment": true},
		"money": {"data_type": "int"},
		"map_position_x": {"data_type": "real", "default": 0.0},
		"map_position_y": {"data_type": "real", "default": 0.0},
		"completed_events": {"data_type": "text", "default": "[]"},
		"current_location": {"data_type": "int", "default": 1},
		"current_boss": {"data_type": "int", "default": 0}
	}
	database.drop_table("Player")
	database.create_table("Player", player_table)
	database.insert_row("Player", {"money": 0, "completed_events": "[]"})
	
	
	var hero_table = {
		"id": {"data_type": "int", "primary_key": true, 
		"not_null": true, "auto_increment": true},
		"name": {"data_type": "text"},
		"image_name":  {"data_type": "text"},
		"deck": {"data_type": "text", "default": "[]"},
		"hp": {"data_type": "int", "default": 30},
		"location": {"data_type": "int", "default": 0}
	}
	database.drop_table("Heroes")
	database.create_table("Heroes", hero_table)
	database.insert_rows("Heroes", 
	[{"name":"Поврежденный рыцарь", "image_name": "Hero.webp", "deck": "[]"},
	{"name":"Странник", "image_name": "Stranger.webp", "deck": "[5,6,7,8,9,10]", "location": 1},
	{"name":"Рыцарь света", "image_name": "KnightOfLight.webp", "deck": "[1,2,5,6,7,8]", "location": 1},
	{"name": "Огненный дракон", "image_name": "LavaDragon.png", "deck": "[1,2,5,6,7,8]", "location": 2},
	{"name": "Командир огенного батальона", "image_name": "FireBattalionCommander.png", "deck": "[1,2,5,6,7,8]", "location": 2},
	{"name": "Лорд льда", "image_name": "IceLord.png", "deck": "[7,6,3,12,13,14]", "location": 3},
	{"name": "Снежный рыцарь", "image_name": "SnowKnight.png", "deck": "[8,9,11,12,13,14]", "location": 3},
	{"name": "Вестник смерти", "image_name": "HarbingerOfDeath.png", "deck": "[11,2,5,6,7,8]", "location": 4},
	{"name": "Песчаный маг", "image_name": "SandWizzard.png", "deck": "[4,2,5,6,7,8]", "location": 4},
	{"name": "Первый жнец", "image_name": "FirstReaper.png", "deck": "[10,2,5,6,7,8]", "location": 5},
	{"name": "Всадники смерти", "image_name": "HorsemenOfDeath.png", "deck": "[11,2,10,6,7,8]", "location": 5}])
	
	var boss_table = {
		"id": {"data_type": "int", "primary_key": true, 
		"not_null": true, "auto_increment": true},
		"name": {"data_type": "text"},
		"image_name": {"data_type": "text"},
		"icon_path": {"data_type": "text"},
		"deck": {"data_type": "text", "default": "[]"},
		"hp": {"data_type": "int", "default": 30},
		"feature": {"data_type": "text"}
	}
	database.drop_table("Bosses")
	database.create_table("Bosses", boss_table)
	database.insert_rows("Bosses",
	[{"name":"Лавовый лорд", "image_name": "LavaLord.png", "icon_path" : "LavaLordIcon.webp", "deck": "[10,11,12,13,14,15]", "feature": "Увеличивает атаку своих карт на 1 в конце своего хода"},
	{"name":"Повелительница разума", "image_name": "MasterOfTheMind.webp", "icon_path" : "MasterOfTheMindIcon.png", "deck": "[10,11,12,13,14,15]", "feature": "В конце своего хода переманивает карту противника со случанойго места(в том числе пустого)"},
	{"name":"Черепаший король", "image_name": "TurtleKing.webp", "icon_path" : "TurtleKingIcon.webp", "deck": "[10,11,12,13,14,15]", "feature": "Получает на 1 ед. урона меньше от любого источника"},
	{"name":"Смерть", "image_name": "Death.webp", "icon_path" : "DeathIcon.png", "deck": "[10,11,12,13,14,15]", "feature": "Наносит 1 ед. урона всем противникам в конце своего хода"}])
	
	
	var feature_table = {
		"id": {"data_type": "int", "primary_key": true, 
		"not_null": true, "auto_increment": true},
		"name": {"data_type": "text"},
		"description": {"data_type": "text"}
	}
	database.drop_table("Features")
	database.create_table("Features", feature_table)
	database.insert_rows("Features", 
	[{"name": "Цепная атака", "description": "Наносит урон карте противника и карте за ней"},
	{"name": "Разогрев", "description": "После атаки получает +1 к атаке и +1 к здоровью"},
	{"name": "Ближний шквал", "description": "После атаки наносит 1 ед. урона ближним картам противника"},
	{"name": "Дальний шквал", "description": "После атаки наносит 1 ед. урона дальним картам противника"},
	{"name": "Безумие", "description": "Перед атакой получает +3 к атаке, но после атаки теряет 1 ед. здоровья"}])
	
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
