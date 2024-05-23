extends Node2D


@onready var slots = [[$CardSlot1, $CardSlot2, $CardSlot3], [$CardSlot4, $CardSlot5, $CardSlot6]]
@onready var enemy_board_position = [[$EnemySlot1.position - Vector2(60, 90),
									$EnemySlot2.position - Vector2(60, 90),
									$EnemySlot3.position - Vector2(60, 90)],
									[$EnemySlot4.position - Vector2(60, 90),
									$EnemySlot5.position - Vector2(60, 90),
									$EnemySlot6.position - Vector2(60, 90)]]
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

var data
const card_base = preload('res://scenes/card_base.tscn')


# Called when the node enters the scene tree for the first time.
func _ready():
	hero2.change_hero(DatabaseService.get_hero(2))
	
	cur_mana.text = "5"
	max_mana.text = "5"
	randomize()
	
	enemy_deck = DatabaseService.get_enemy_deck(2)
	enemy_deck.shuffle()

	data = DatabaseService.get_deck()
	data.shuffle()
	
	enemy_play()


	
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
				player_board[i][j].position.x += 20
				await get_tree().create_timer(0.3).timeout
				player_board[i][j].position.x -= 20
				var features = DatabaseService.get_features(JSON.parse_string(player_board[i][j].card.description))
				if enemy_board[0][j] != null:
					if enemy_board[0][j].get_damage(player_board[i][j].deal_damage()):
						await get_tree().create_timer(0.3).timeout
						remove_child(enemy_board[0][j])
						enemy_board[0][j] = null
					if "Цепная атака" in features:
						if enemy_board[1][j] != null:
							if enemy_board[1][j].get_damage(player_board[i][j].deal_damage()):
								await get_tree().create_timer(0.3).timeout
								remove_child(enemy_board[1][j])
								enemy_board[1][j] = null
				elif enemy_board[1][j] != null:
					if enemy_board[1][j].get_damage(player_board[i][j].deal_damage()):
						await get_tree().create_timer(0.3).timeout
						remove_child(enemy_board[1][j])
						enemy_board[1][j] = null
				else:
					hero2.change_hp(-player_board[i][j].deal_damage())
				if "Разогрев" in features:
					player_board[i][j].change_stats(1, 1)

func enemy_turn():
	for i in range(enemy_board.size()):
		for j in range(enemy_board[0].size()):
			if enemy_board[i][j] != null:
				enemy_board[i][j].position.x -= 20
				await get_tree().create_timer(0.3).timeout
				enemy_board[i][j].position.x += 20
				if player_board[0][j] != null:
					if player_board[0][j].get_damage(enemy_board[i][j].deal_damage()):
						await get_tree().create_timer(0.3).timeout
						remove_child(player_board[0][j])
						slots[0][j].occupied = false
						player_board[0][j] = null
				elif player_board[1][j] != null:
					if player_board[1][j].get_damage(enemy_board[i][j].deal_damage()):
						await get_tree().create_timer(0.3).timeout
						remove_child(player_board[1][j])
						slots[1][j].occupied = false
						player_board[1][j] = null
				else:
					hero1.change_hp(-enemy_board[i][j].deal_damage())

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
		
		#for i in range(2):
			#if flag:
				#for j in range(3):
					#if enemy_board[i][j] == null:
						#card1.position = enemy_board_position[i][j]
						#enemy_board[i][j] = card1
						#add_child(card1)
						#enemy_index += 1
						#flag = false
						#break

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
	
	if int(max_mana.text) != 10:
		max_mana.text = str(int(max_mana.text) + 1)
		cur_mana.text = max_mana.text
	
	await draw_card()
	
	for i in range(hand_cards.size()):
		if hand_cards[i] != null:
			hand_cards[i].is_enable = true
	
	$EndTurn.disabled = false


func _on_button_pressed():
	var earned_money = randi_range(10, 50)
	DatabaseService.add_money(earned_money)
	$Popup/CenterContainer/Label.text = 'Вы победили.\nВы заработали ' + str(earned_money) + '$'
	$Popup.popup(Rect2i(450, 250, 1020, 560))



func _on_popup_popup_hide():
	if hero1.get_hp() <= 0:
		get_tree().change_scene_to_file("res://scenes/node_2d.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/map.tscn")
