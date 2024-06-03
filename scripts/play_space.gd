extends Node2D


@onready var slots = [[$CardSlot1, $CardSlot2, $CardSlot3], [$CardSlot4, $CardSlot5, $CardSlot6]]
@onready var enemy_board_position = [[$EnemySlot1.position - Vector2(60, 90),
									$EnemySlot2.position - Vector2(60, 90),
									$EnemySlot3.position - Vector2(60, 90)],
									[$EnemySlot4.position - Vector2(60, 90),
									$EnemySlot5.position - Vector2(60, 90),
									$EnemySlot6.position - Vector2(60, 90)]]
@onready var player_board_position = [[$PlayerSlot1.position - Vector2(60, 90),
									$PlayerSlot2.position - Vector2(60, 90),
									$PlayerSlot3.position - Vector2(60, 90)],
									[$PlayerSlot4.position - Vector2(60, 90),
									$PlayerSlot5.position - Vector2(60, 90),
									$PlayerSlot6.position - Vector2(60, 90)]]
var player_board = [[null, null, null], [null, null, null]] 
var enemy_board = [[null, null, null], [null, null, null]]
var hand_position = [Vector2(650, 800), Vector2(800, 800), 
					Vector2(950, 800), Vector2(1100, 800)]
var hand_cards = [null, null, null, null]
var enemy_hand = [null, null, null, null]
var enemy_deck
@onready var max_mana = $MaxMana
@onready var cur_mana = $CurrentMana
@onready var hero1 = $HeroBase
@onready var hero2 = $HeroBase2

var card_index = 0
var enemy_index = 0
var earned_money = randi_range(10, 50)

var boss_id = 0

var data
const card_base = preload('res://scenes/card_base.tscn')


func _ready():
	$Background.texture = load("res://src/background_arts/" + str(DatabaseService.get_current_room()) + ".jpg")
	$Background.scale *= get_viewport().get_visible_rect().size / $Background.texture.get_size()
	
	boss_id = DatabaseService.get_current_boss_id()
	if boss_id == 0:
		var temp = DatabaseService.get_random_hero_in_current_room()
		hero2.change_hero(temp[0])
		enemy_deck = temp[1]
	else:
		hero2.change_hero(DatabaseService.get_boss(boss_id))
		enemy_deck = DatabaseService.get_boss_deck(boss_id)
		$BossTooltip/Sprite2D.texture = load(hero2.hero.icon_path)
		$BossTooltip/Sprite2D.scale *= Vector2(150, 150) / $BossTooltip/Sprite2D.texture.get_size()
		$BossTooltip.visible = true
		$BossTooltip/ColorRect.color = Color('7b6a63')
		$BossTooltip/ColorRect.tooltip_text = hero2.hero.feature

	enemy_deck.shuffle()

	cur_mana.text = "5"
	max_mana.text = "5"
	
	data = DatabaseService.get_deck()
	data.shuffle()
	
	#enemy_play()
	#enemy_play()


	await draw_card()
	await draw_card()
	

func _process(delta):
	for i in range(hand_cards.size()):
		if hand_cards[i] != null and hand_cards[i].is_played:
			for j in range(slots.size()):
					for k in range(slots[0].size()):
						if slots[j][k].card_base == hand_cards[i]:
							player_board[j][k] = hand_cards[i]
							if hand_cards[i] != null:
								cur_mana.text = str(int(cur_mana.text) - hand_cards[i].get_manacost())
							hand_cards[i] = null
		if hand_cards[i] != null:
			hand_cards[i].enough_mana = (hand_cards[i].get_manacost() <= int(cur_mana.text))
			
	if data.size() - card_index == 0:
		$MarginContainer/CardBack.visible = false
	$MarginContainer/ColorRect.tooltip_text = 'В вашей колоде ' + str(data.size() - card_index) + ' карт'
	
	if hero1.get_hp() <= 0:
		DatabaseService.add_money(earned_money)
		$Popup/CenterContainer/Label.text = 'Вы проиграли.\nИгра окончена.'
		$Popup.popup(Rect2i(450, 250, 1020, 560))
	if hero2.get_hp() <= 0:
		DatabaseService.add_money(earned_money)
		if boss_id == 4:
			$Popup/CenterContainer/Label.text = 'Вы прошли игру.'
		else:
			$Popup/CenterContainer/Label.text = 'Вы победили.\nВы заработали ' + str(earned_money) + '$'
		$Popup.popup(Rect2i(450, 250, 1020, 560))
	
	

func draw_card():
	for i in range(hand_cards.size()):
		if hand_cards[i] == null and card_index != data.size():
			var card = card_base.instantiate()
			hand_cards[i] = card
			hand_cards[i].card = data[card_index]
			hand_cards[i].is_enable = false
			card_index += 1
			add_child(hand_cards[i])
			hand_cards[i].position = Vector2(1517, 706)
			var tween = get_tree().create_tween()
			tween.tween_property(hand_cards[i], "position", hand_position[i], 0.5)
			await get_tree().create_timer(0.5).timeout
			hand_cards[i].is_enable = true
			break

func player_turn():
	for i in range(player_board.size()):
		for j in range(player_board[0].size()):
			if player_board[i][j] != null:
				var features = DatabaseService.get_features(JSON.parse_string(player_board[i][j].card.description))
				if 'Безумие' in features:
					player_board[i][j].change_stats(3, 0)
				player_board[i][j].position.x += 20
				await get_tree().create_timer(0.5).timeout
				player_board[i][j].position.x -= 20
				if enemy_board[0][j] != null:
					if await enemy_board[0][j].get_damage(player_board[i][j].deal_damage()):
						await get_tree().create_timer(0.5).timeout
						remove_child(enemy_board[0][j])
						enemy_board[0][j] = null
					if "Цепная атака" in features:
						if enemy_board[1][j] != null:
							if await enemy_board[1][j].get_damage(player_board[i][j].deal_damage()):
								await get_tree().create_timer(0.5).timeout
								remove_child(enemy_board[1][j])
								enemy_board[1][j] = null
				elif enemy_board[1][j] != null:
					if await enemy_board[1][j].get_damage(player_board[i][j].deal_damage()):
						await get_tree().create_timer(0.5).timeout
						remove_child(enemy_board[1][j])
						enemy_board[1][j] = null
				else:
					if boss_id == 3:
						$BossTooltip/ColorRect.color = Color('e00000')
						await get_tree().create_timer(0.5).timeout 
						hero2.change_hp(-player_board[i][j].deal_damage() + 1)
						await get_tree().create_timer(0.5).timeout 
						$BossTooltip/ColorRect.color = Color('7b6a63')
					else:
						hero2.change_hp(-player_board[i][j].deal_damage())
				if "Разогрев" in features:
					player_board[i][j].change_stats(1, 1)
				if "Ближний шквал" in features:
					for tj in range(enemy_board[0].size()):
						if enemy_board[0][tj] != null:
							if await enemy_board[0][tj].get_damage(1):
								await get_tree().create_timer(0.5).timeout
								remove_child(enemy_board[0][tj])
								enemy_board[0][tj] = null
				if "Дальний шквал" in features:
					for tj in range(enemy_board[0].size()):
						if enemy_board[1][tj] != null:
							if await enemy_board[1][tj].get_damage(1):
								await get_tree().create_timer(0.5).timeout
								remove_child(enemy_board[1][tj])
								enemy_board[1][tj] = null
				if 'Безумие' in features:
					if await player_board[i][j].get_damage(1):
						await get_tree().create_timer(0.5).timeout
						remove_child(player_board[i][j])
						slots[i][j].occupied = false
						player_board[i][j] = null


func enemy_turn():
	for i in range(enemy_board.size()):
		for j in range(enemy_board[0].size()):
			if enemy_board[i][j] != null:
				var features = DatabaseService.get_features(JSON.parse_string(enemy_board[i][j].card.description))
				if 'Безумие' in features:
					enemy_board[i][j].change_stats(3, 0)
				enemy_board[i][j].position.x -= 20
				await get_tree().create_timer(0.5).timeout
				enemy_board[i][j].position.x += 20
				if player_board[0][j] != null:
					if await player_board[0][j].get_damage(enemy_board[i][j].deal_damage()):
						await get_tree().create_timer(0.5).timeout
						remove_child(player_board[0][j])
						slots[0][j].occupied = false
						player_board[0][j] = null
					if "Цепная атака" in features:
						if player_board[1][j] != null:
							if await player_board[1][j].get_damage(enemy_board[i][j].deal_damage()):
								await get_tree().create_timer(0.5).timeout
								remove_child(enemy_board[1][j])
								player_board[1][j] = null
				elif player_board[1][j] != null:
					if await player_board[1][j].get_damage(enemy_board[i][j].deal_damage()):
						await get_tree().create_timer(0.5).timeout
						remove_child(player_board[1][j])
						slots[1][j].occupied = false
						player_board[1][j] = null
				else:
					hero1.change_hp(-enemy_board[i][j].deal_damage())
				if "Разогрев" in features:
					enemy_board[i][j].change_stats(1, 1)
				if "Ближний шквал" in features:
					for tj in range(player_board[0].size()):
						if player_board[0][tj] != null:
							if await player_board[0][tj].get_damage(1):
								await get_tree().create_timer(0.5).timeout
								remove_child(player_board[0][tj])
								player_board[0][tj] = null
				if "Дальний шквал" in features:
					for tj in range(player_board[0].size()):
						if player_board[1][tj] != null:
							if await player_board[1][tj].get_damage(1):
								await get_tree().create_timer(0.5).timeout
								remove_child(player_board[1][tj])
								player_board[1][tj] = null
				if 'Безумие' in features:
					if await enemy_board[i][j].get_damage(1):
						await get_tree().create_timer(0.5).timeout
						remove_child(enemy_board[i][j])
						enemy_board[i][j] = null

func enemy_play():
	if enemy_index != enemy_deck.size():
		var card1 = card_base.instantiate()
		card1.card = enemy_deck[enemy_index]
		card1.is_enable = false
		var flag = true
		var free_slots = []
		for i in range(2):
			for j in range(3):
				if enemy_board[i][j] == null:
					free_slots.append([i, j])
		var res = free_slots.pick_random()
		if res != null:
			card1.position = enemy_board_position[res[0]][res[1]]
			enemy_board[res[0]][res[1]] = card1
			add_child(card1)
			enemy_index += 1

func _on_end_turn_pressed():
	
	$EndTurn.disabled = true
	for i in range(hand_cards.size()):
		if hand_cards[i] != null:
			hand_cards[i].is_enable = false
	await player_turn()
	await get_tree().create_timer(0.5).timeout
	enemy_play()
	await enemy_turn()
	await get_tree().create_timer(0.5).timeout
	if boss_id != 0:
		await boss_feature()
	await get_tree().create_timer(0.5).timeout
	
	
	if int(max_mana.text) != 10:
		max_mana.text = str(int(max_mana.text) + 1)
		cur_mana.text = max_mana.text
	
	await draw_card()
	
	for i in range(hand_cards.size()):
		if hand_cards[i] != null:
			hand_cards[i].is_enable = true
	
	$EndTurn.disabled = false


func boss_feature():
	match boss_id:
		1:
			$BossTooltip/ColorRect.color = Color('e00000')
			await get_tree().create_timer(0.5).timeout 
			for i in range(enemy_board.size()):
				for j in range(enemy_board[0].size()):
					if enemy_board[i][j] != null:
						enemy_board[i][j].change_stats(1, 0)
		4: 
			$BossTooltip/ColorRect.color = Color('e00000')
			await get_tree().create_timer(0.5).timeout 
			hero1.change_hp(-1)
			for i in range(player_board.size()):
				for j in range(player_board[0].size()):
					if player_board[i][j] != null:
						if await player_board[i][j].get_damage(1):
							await get_tree().create_timer(0.5).timeout
							remove_child(player_board[i][j])
							slots[i][j].occupied = false
							player_board[i][j] = null
		2:
			$BossTooltip/ColorRect.color = Color('e00000')
			await get_tree().create_timer(0.5).timeout 
			var free_slots = []
			for i in range(2):
				for j in range(3):
					if enemy_board[i][j] == null:
						free_slots.append([i, j])
			var ri = randi_range(0, 1)
			var rj = randf_range(0, 2)
			var res = free_slots.pick_random()
			if res != null and player_board[ri][rj] != null:
				player_board[ri][rj].position = enemy_board_position[res[0]][res[1]]
				enemy_board[res[0]][res[1]] = player_board[ri][rj]
				slots[ri][rj].occupied = false
				player_board[ri][rj] = null
				
	
	await get_tree().create_timer(0.5).timeout
	$BossTooltip/ColorRect.color = Color('7b6a63')


func _on_button_pressed():
	var earned_money = randi_range(10, 50)
	DatabaseService.add_money(earned_money)
	$Popup/CenterContainer/Label.text = 'Вы победили.\nВы заработали ' + str(earned_money) + '$'
	$Popup.popup(Rect2i(450, 250, 1020, 560))



func _on_popup_popup_hide():
	DatabaseService.set_current_boss(0)
	if hero1.get_hp() <= 0:
		get_tree().change_scene_to_file("res://scenes/node_2d.tscn")
	else:
		if boss_id in range(1, 4):
			DatabaseService.change_room(5)
		elif boss_id == 4:
			get_tree().change_scene_to_file("res://scenes/node_2d.tscn")
			return 
		get_tree().change_scene_to_file("res://scenes/map.tscn")
