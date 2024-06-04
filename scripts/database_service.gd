extends Node

func add_to_colletion(name):
	var database = SQLite.new()
	database.path = 'res://data.db'
	database.open_db()
	database.update_rows("CardDataBase", "name==\'"+name+"\'", {"in_collection": true})
	
func replace_in_deck(old_name, new_name):
	var database = SQLite.new()
	database.path = 'res://data.db'
	database.open_db()
	database.update_rows("CardDataBase", "name==\'"+old_name+"\'", {"in_deck": false})
	database.update_rows("CardDataBase", "name==\'"+new_name+"\'", {"in_deck": true})

func get_enemy_deck(id):
	var database = SQLite.new()
	database.path = 'res://data.db'
	database.open_db()
	var row = database.select_rows("Heroes", "id=="+str(id), ["deck"])[0]["deck"]
	var res = []
	for c in JSON.parse_string(row):
		res.append(get_card(c, true))
	return res
	
func get_boss_deck(id):
	var database = SQLite.new()
	database.path = 'res://data.db'
	database.open_db()
	var row = database.select_rows("Bosses", "id=="+str(id), ["deck"])[0]["deck"]
	var res = []
	for c in JSON.parse_string(row):
		res.append(get_card(c, true))
	return res
	
func get_deck():
	var database = SQLite.new()
	database.path = 'res://data.db'
	database.open_db()
	var rows = database.select_rows("CardDataBase", "in_deck=1", ["*"])
	var res = []
	for row in rows:
		var card = MinionCard.new(row["name"], row["description"], 
						row["image_name"], row["rarity"], 
						row["manacost"], row["attack"], row["hp"])
		res.append(card)
	return res

func get_collection(without_deck=false):
	var database = SQLite.new()
	database.path = 'res://data.db'
	database.open_db()
	var rows
	if without_deck:
		rows = database.select_rows("CardDataBase", "in_deck=0 and in_collection=1", ["*"])
	else:
		rows = database.select_rows("CardDataBase", "in_collection=1", ["*"])
	var res = []
	for row in rows:
		var card = MinionCard.new(row["name"], row["description"], 
						row["image_name"], row["rarity"], 
						row["manacost"], row["attack"], row["hp"])
		res.append(card)
	return res
	
func get_all_cards(without_collection):
	var database = SQLite.new()
	database.path = 'res://data.db'
	database.open_db()
	var rows
	if without_collection:
		rows = database.select_rows("CardDataBase", "in_deck=0 and in_collection=0", ["*"])
	else:
		rows = database.select_rows("CardDataBase", "in_deck=0", ["*"])
	var res = []
	for row in rows:
		var card = MinionCard.new(row["name"], row["description"], 
						row["image_name"], row["rarity"], 
						row["manacost"], row["attack"], row["hp"])
		res.append(card)
	return res
	
func get_card(id, enemy=false):
	var database = SQLite.new()
	database.path = 'res://data.db'
	database.open_db()
	var row = database.select_rows("CardDataBase", "id="+str(id), ["*"])[0]
	if enemy:
		row = database.select_rows("EnemyCardDataBase", "id="+str(id), ["*"])[0]
	return MinionCard.new(row["name"], row["description"], 
						row["image_name"], row["rarity"], 
						row["manacost"], row["attack"], row["hp"])

func get_money():
	var database = SQLite.new()
	database.path = 'res://data.db'
	database.open_db()
	return database.select_rows("Player", "id==1", ["money"])[0]["money"]

func add_money(money):
	var database = SQLite.new()
	database.path = 'res://data.db'
	database.open_db()
	var cur_money = database.select_rows("Player", "id==1", ["money"])[0]["money"]
	database.update_rows("Player", "id==1", {"money": cur_money + money})

func get_experince():
	var database = SQLite.new()
	database.path = 'res://data.db'
	database.open_db()
	return database.select_rows("Player", "id==1", ["experience"])[0]["experience"]

func add_experince(experience):
	var database = SQLite.new()
	database.path = 'res://data.db'
	database.open_db()
	var cur_experience = database.select_rows("Player", "id==1", ["experience"])[0]["experience"]
	database.update_rows("Player", "id==1", {"experience":  cur_experience + experience})

func set_map_position(pos):
	var database = SQLite.new()
	database.path = 'res://data.db'
	database.open_db()
	database.update_rows("Player", "id==1", {"map_position_x": pos.x, "map_position_y": pos.y})

func get_map_position():
	var database = SQLite.new()
	database.path = 'res://data.db'
	database.open_db()
	var res = database.select_rows("Player", "id==1", ["map_position_x", "map_position_y"])[0]
	return Vector2(res["map_position_x"], res["map_position_y"])

func add_completed_event(position):
	var database = SQLite.new()
	database.path = 'res://data.db'
	database.open_db()
	var cur = JSON.parse_string(database.select_rows("Player", "id==1", ["completed_events"])[0]["completed_events"])
	cur.append([position.x, position.y])
	database.update_rows("Player", "id==1", {"completed_events": str(cur)})

func get_completed_events():
	var database = SQLite.new()
	database.path = 'res://data.db'
	database.open_db()
	return JSON.parse_string(database.select_rows("Player", "id==1", ["completed_events"])[0]["completed_events"])

func clear_completed_events():
	var database = SQLite.new()
	database.path = 'res://data.db'
	database.open_db()
	database.update_rows("Player", "id==1", {"completed_events": "[]"})

func get_hero(id: int):
	var database = SQLite.new()
	database.path = 'res://data.db'
	database.open_db()
	var row = database.select_rows("Heroes", "id="+str(id), ["*"])[0]
	return Hero.new(row["name"], row["image_name"],
					JSON.parse_string(row["deck"]), row["hp"])

func get_random_hero_in_current_room():
	var room_id = get_current_room()
	var database = SQLite.new()
	database.path = 'res://data.db'
	database.open_db()
	var rows = database.select_rows("Heroes", "location="+str(room_id), ["*"])
	var row = rows.pick_random()
	return [Hero.new(row["name"], row["image_name"],
					JSON.parse_string(row["deck"]), row["hp"]),
					get_enemy_deck(row["id"])]
					

func get_features(arr: Array, to_string=false):
	var database = SQLite.new()
	database.path = 'res://data.db'
	database.open_db()
	var res
	if to_string:
		res = ""
		for i in arr:
			res += database.select_rows("Features", "id=="+str(i), ["name"])[0]["name"] + ', '
		if res.ends_with(', '):
			res = res.erase(res.length() - 2)
	else:
		res = []
		for i in arr:
			res.append(database.select_rows("Features", "id=="+str(i), ["name"])[0]["name"])
	return res

func get_features_tooltip(arr: Array):
	var database = SQLite.new()
	database.path = 'res://data.db'
	database.open_db()
	var res = ""
	for i in arr:
		var row = database.select_rows("Features", "id=="+str(i), ["name", "description"])[0]
		res += row["name"] + ": " + row["description"] + '\n'
	return res

func add_feature_to_card(card_name, feature_name):
	var database = SQLite.new()
	database.path = 'res://data.db'
	database.open_db()
	var feature_id = database.select_rows("Features", "name==\'"+feature_name+"\'", ["id"])[0]["id"]
	var features = JSON.parse_string(database.select_rows("CardDataBase", "name==\'"+card_name+"\'", ["description"])[0]["description"])
	features.append(int(feature_id))
	database.update_rows("CardDataBase", "name==\'"+card_name+"\'", {"description": str(features)})
	
	
func change_room(new_room: int):
	var database = SQLite.new()
	database.path = 'res://data.db'
	database.open_db()
	database.update_rows("Player", "id==1", {"current_location": new_room})

func get_current_room():
	var database = SQLite.new()
	database.path = 'res://data.db'
	database.open_db()
	return database.select_rows("Player", "id==1", ["current_location"])[0]["current_location"]

func set_current_boss(new_boss: int):
	var database = SQLite.new()
	database.path = 'res://data.db'
	database.open_db()
	database.update_rows("Player", "id==1", {"current_boss": new_boss})

func get_current_boss_id():
	var database = SQLite.new()
	database.path = 'res://data.db'
	database.open_db()
	return database.select_rows("Player", "id==1", ["current_boss"])[0]["current_boss"]

func get_boss(id: int):
	var database = SQLite.new()
	database.path = 'res://data.db'
	database.open_db()
	var row = database.select_rows("Bosses", "id="+str(id), ["*"])[0]
	return Boss.new(row["name"], row["image_name"],
					JSON.parse_string(row["deck"]), row["hp"], row["feature"], row["icon_path"])
