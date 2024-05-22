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
		"description": {"data_type": "text"},
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
		[arr_to_dict(['Killer', 'Deal a great damage', 'Killer.png', AbstractCard.Rarity.Common, 2, 5, 1]),
		arr_to_dict(['Warrior', 'Nothing', 'Warrior.png', AbstractCard.Rarity.Rare, 2, 3, 4]),
		arr_to_dict(['Spirit', '', 'Spirit.webp', AbstractCard.Rarity.Epic, 5, 7, 7]),
		arr_to_dict(['Shadow', '', 'ShadowWarrior.png', AbstractCard.Rarity.Rare, 6, 6, 6]),
		arr_to_dict(['Dragon', '', 'Dragon.webp', AbstractCard.Rarity.Legendary, 8, 10, 10]),
		arr_to_dict(['Baby dragon', '', 'DragonBaby.webp', AbstractCard.Rarity.Common, 1, 1, 2]),
		arr_to_dict(['Druid', '', 'Druid.webp', AbstractCard.Rarity.Rare, 2, 3, 2]),
		arr_to_dict(['Lion', '', 'Lion.webp', AbstractCard.Rarity.Rare, 4, 4, 4]),
		arr_to_dict(['Owl', '', 'Owl.webp', AbstractCard.Rarity.Common, 1, 2, 1]),
		arr_to_dict(['Demon', '', 'DemonKnight.webp', AbstractCard.Rarity.Epic, 3, 4, 3])])
	
	database.update_rows("CardDataBase", 
		"id==1 or id==2 or id==3 or id==4 or id==5 or id==6", 
		{"in_deck": true, "in_collection": true})
	
	var player_table = {
		"id": {"data_type":"int", "primary_key": true, "not_null": true, "auto_increment": true},
		"money": {"data_type": "int"},
		"experience": {"data_type": "int"},
		"map_position_x": {"data_type": "real", "default": 0.0},
		"map_position_y": {"data_type": "real", "default": 0.0},
		"completed_events": {"data_type": "text", "default": "[]"}
	}
	database.drop_table("Player")
	database.create_table("Player", player_table)
	database.insert_row("Player", {"money": 200, "experience": 20, "completed_events": "[]"})
	
	get_tree().change_scene_to_file("res://scenes/map.tscn")
	

func arr_to_dict(arr: Array) -> Dictionary:
	return {"name": arr[0], "description": arr[1],
			"image_name": arr[2], "rarity": arr[3],
			"manacost": arr[4], "attack": arr[5],
			"hp": arr[6]}

func _on_exit_button_pressed():
	get_tree().quit()


func _on_continue_button_pressed():
	get_tree().change_scene_to_file("res://scenes/map.tscn")
