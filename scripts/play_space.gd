extends Node2D


@onready var slots = [$CardSlot1, $CardSlot2, $CardSlot3]
@onready var enemy_board_position = [$EnemySlot1.position - Vector2(60, 90),
									$EnemySlot2.position - Vector2(60, 90),
									$EnemySlot3.position - Vector2(60, 90)]
var player_board = [null, null, null]
var enemy_board = [null, null, null]
var hand_position = [Vector2(650, 800), Vector2(800, 800), 
					Vector2(950, 800), Vector2(1100, 800)]
var hand_cards = [null, null, null, null]
@onready var max_mana = $MaxMana
@onready var cur_mana = $CurrentMana

var card_index = 0

var data
const card_base = preload('res://scenes/card_base.tscn')

# Called when the node enters the scene tree for the first time.
func _ready():
	cur_mana.text = "5"
	max_mana.text = "5"
	randomize()
	var deck = Deck.get_instance()
	
	data = deck.card_arr.duplicate()
	data.shuffle()
	
	var card1 = card_base.instantiate()
	card1.card = data[0]
	card1.position = enemy_board_position[0]
	card1.is_enable = false
	enemy_board[0] = card1
	add_child(card1)
	
	await draw_card()
	await draw_card()
	await draw_card()

func _process(delta):
	for i in range(hand_cards.size()):
		if hand_cards[i] != null and hand_cards[i].is_played:
			for j in range(slots.size()):
				if slots[j].card_base == hand_cards[i]:
					player_board[j] = hand_cards[i]
					if hand_cards[i] != null:
						cur_mana.text = str(int(cur_mana.text) - hand_cards[i].get_manacost())
					hand_cards[i] = null
		if hand_cards[i] != null:
			hand_cards[i].enough_mana = (hand_cards[i].get_manacost() <= int(cur_mana.text))

func draw_card():
	for i in range(hand_cards.size()):
		if hand_cards[i] == null and card_index != data.size():
			var card = card_base.instantiate()
			hand_cards[i] = card
			hand_cards[i].card = data[card_index]
			hand_cards[i].is_enable = false
			card_index += 1
			add_child(hand_cards[i])
			hand_cards[i].position = Vector2(1400, 400)
			var tween = get_tree().create_tween()
			tween.tween_property(hand_cards[i], "position", hand_position[i], 0.5)
			await get_tree().create_timer(0.5).timeout
			hand_cards[i].is_enable = true
			break

func player_turn():
	for i in range(player_board.size()):
		if player_board[i] != null:
			player_board[i].position.y -= 20
			await get_tree().create_timer(0.3).timeout
			player_board[i].position.y += 20
			if enemy_board[i] != null:
				if enemy_board[i].get_damage(player_board[i].deal_damage()):
					await get_tree().create_timer(0.3).timeout
					remove_child(enemy_board[i])
					enemy_board[i] = null

func enemy_turn():
	for i in range(enemy_board.size()):
		if enemy_board[i] != null:
			enemy_board[i].position.y += 20
			await get_tree().create_timer(0.3).timeout
			enemy_board[i].position.y -= 20
			if player_board[i] != null:
				if player_board[i].get_damage(enemy_board[i].deal_damage()):
					await get_tree().create_timer(0.3).timeout
					remove_child(player_board[i])
					slots[i].occupied = false
					player_board[i] = null

func _on_end_turn_pressed():
	$EndTurn.disabled = true
	for i in range(hand_cards.size()):
		if hand_cards[i] != null:
			hand_cards[i].is_enable = false

	await player_turn()
	await get_tree().create_timer(0.5).timeout
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
	Global.money += earned_money
	$Popup/CenterContainer/Label.text = 'Вы победили.\nВы заработали ' + str(earned_money) + '$'
	$Popup.popup(Rect2i(450, 250, 1020, 560))



func _on_popup_popup_hide():
	get_tree().change_scene_to_file("res://scenes/map.tscn")
