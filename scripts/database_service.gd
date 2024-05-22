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
	
func get_card(id):
	var database = SQLite.new()
	database.path = 'res://data.db'
	database.open_db()
	var row = database.select_rows("CardDataBase", "id="+str(id), ["*"])[0]
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