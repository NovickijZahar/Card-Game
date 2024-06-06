extends Node


@onready var http = $HTTPRequest
@onready var hand = $Hand

@onready var host = $Host 
@onready var join = $Join
@onready var send = $Send
@onready var username = $Username 
@onready var message = $Message
@onready var messages = $Messages
@onready var cur_mana_label = $ManaContainer/CurManaLabel
@onready var max_mana_label = $ManaContainer/MaxManaLabel
@onready var player_hero = $HeroBase
@onready var enemy_hero = $EnemyBase

var max_mana = 0
var cur_mana = 0

var deck
var deck_index = 0


var usrname: String
var msg: String

const cardbase = preload("res://scenes/card_base.tscn")
var selected_slot = 0
var in_slot: bool
var data = []

func _ready():
	$Background.texture = load("res://src/background_arts/2.jpg")
	$Background.scale *= get_viewport().get_visible_rect().size / $Background.texture.get_size()
	deck = DatabaseService.get_deck()
	deck.shuffle()
	$Button.disabled = true
	player_hero.change_hero(DatabaseService.get_hero(1))
	enemy_hero.change_hero(DatabaseService.get_hero(2))

func _on_button_pressed():
	$Button.disabled = true
	for card in $Hand.get_children():
		card.is_enable2 = false
	var player_slots = $PlayerSlots.get_children()
	var enemy_slots = $EnemySlots.get_children()
	for i in player_slots.size():
		if player_slots[i].get_child_count() != 0:
			var card = player_slots[i].get_child(0)
			card.position.x += 20
			if i in [0, 1]:
				if enemy_slots[0].get_child_count():
					enemy_slots[0].get_child(0).get_damage(card.deal_damage())
				elif enemy_slots[1].get_child_count():
					enemy_slots[1].get_child(0).get_damage(card.deal_damage())
				else:
					enemy_hero.change_hp(-card.card.attack)
			elif i in [2, 3]:
				if enemy_slots[2].get_child_count():
					enemy_slots[2].get_child(0).get_damage(card.deal_damage())
				elif enemy_slots[3].get_child_count():
					enemy_slots[3].get_child(3).get_damage(card.deal_damage())
				else:
					enemy_hero.change_hp(-card.card.attack)
			elif i in [4, 5]:
				if enemy_slots[4].get_child_count():
					enemy_slots[4].get_child(0).get_damage(card.deal_damage())
				elif enemy_slots[5].get_child_count():
					enemy_slots[5].get_child(3).get_damage(card.deal_damage())
				else:
					enemy_hero.change_hp(-card.card.attack)
			await get_tree().create_timer(0.5).timeout
			card.position.x -= 20
	rpc("turn_rpc", usrname, JSON.stringify(data))
	data = []

func _process(_delta):
	for card in hand.get_children():
		if card == Global.selected_card and card.is_enable2:
			card.get_child(0).get_child(0).visible = true
			if card.card.manacost <= int(cur_mana_label.text):
				card.get_child(0).get_child(0).color = Color('5bae83')
			else:
				card.get_child(0).get_child(0).color = Color('ff301a')
		else:
			card.get_child(0).get_child(0).visible = false
	if Input.is_action_just_pressed("click"):
		if Global.selected_card != null and selected_slot != 0 and in_slot \
			and Global.selected_card.is_enable2 and Global.selected_card.card.manacost <= int(cur_mana_label.text):
			var selected_card = cardbase.instantiate()
			selected_card.card = Global.selected_card.card
			match selected_slot:
				1: $PlayerSlots/Slot1.add_child(selected_card)
				2: $PlayerSlots/Slot2.add_child(selected_card)
				3: $PlayerSlots/Slot3.add_child(selected_card)
				4: $PlayerSlots/Slot4.add_child(selected_card)
				5: $PlayerSlots/Slot5.add_child(selected_card)
				6: $PlayerSlots/Slot6.add_child(selected_card)
			cur_mana_label.text = str(int(cur_mana_label.text) - selected_card.card.manacost)
			data.append([selected_slot, DatabaseService.get_card_id(Global.selected_card.card.name)])
			hand.remove_child(Global.selected_card)
			selected_slot = 0
			Global.selected_card = null
	for slot in $PlayerSlots.get_children():
		if slot.get_child_count() != 0:
			if slot.get_child(0).get_hp() <= 0:
				await get_tree().create_timer(0.3).timeout
				slot.remove_child(slot.get_child(0))
	for slot in $EnemySlots.get_children():
		if slot.get_child_count() != 0:
			if slot.get_child(0).get_hp() <= 0:
				await get_tree().create_timer(0.3).timeout
				slot.remove_child(slot.get_child(0))
	if player_hero.get_hp() <= 0:
		$Popup/CenterContainer/Label.text = "Вы проиграли"
		$Popup.popup(Rect2i(450, 250, 1020, 560))
	if enemy_hero.get_hp() <= 0:
		$Popup/CenterContainer/Label.text = "Вы выиграли"
		$Popup.popup(Rect2i(450, 250, 1020, 560))
	

func _on_color_rect_mouse_entered():
	if $PlayerSlots/Slot1.get_child_count() == 0:
		selected_slot = 1
		in_slot = true
func _on_color_rect_2_mouse_entered():
	if $PlayerSlots/Slot2.get_child_count() == 0:
		selected_slot = 2
		in_slot = true
func _on_color_rect_3_mouse_entered():
	if $PlayerSlots/Slot3.get_child_count() == 0:
		selected_slot = 3
		in_slot = true
func _on_color_rect_4_mouse_entered():
	if $PlayerSlots/Slot4.get_child_count() == 0:
		selected_slot = 4
		in_slot = true
func _on_color_rect_5_mouse_entered():
	if $PlayerSlots/Slot5.get_child_count() == 0:
		selected_slot = 5
		in_slot = true
func _on_color_rect_6_mouse_entered():
	if $PlayerSlots/Slot6.get_child_count() == 0:
		selected_slot = 6
		in_slot = true
	
func _on_slot_1_mouse_exited():
	in_slot = false
func _on_slot_2_mouse_exited():
	in_slot = false
func _on_slot_3_mouse_exited():
	in_slot = false
func _on_slot_4_mouse_exited():
	in_slot = false
func _on_slot_5_mouse_exited():
	in_slot = false
func _on_slot_6_mouse_exited():
	in_slot = false


func _on_host_pressed():
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(1027)
	get_tree().set_multiplayer(SceneMultiplayer.new(),self.get_path())
	multiplayer.multiplayer_peer = peer
	$Button.disabled = false
	draw_card()
	draw_card()
	draw_card()
	joined()

func _on_join_pressed():
	var peer = ENetMultiplayerPeer.new()
	peer.create_client("127.0.0.1", 1027)
	get_tree().set_multiplayer(SceneMultiplayer.new(),self.get_path())
	multiplayer.multiplayer_peer = peer
	$Button.disabled = false
	draw_card()
	draw_card()
	draw_card()
	player_hero.change_hero(DatabaseService.get_hero(2))
	enemy_hero.change_hero(DatabaseService.get_hero(1))
	_on_button_pressed()
	joined()

func _on_send_pressed():
	rpc("msg_rpc", usrname, message.text)
	message.text = ""
	
@rpc("any_peer", "call_local")
func msg_rpc(usrnm, data):
	messages.text += str(usrnm, ": ", data, '\n')

@rpc("any_peer", "call_local")
func turn_rpc(usrnm, data):
	if usrnm != usrname:
		for el in JSON.parse_string(data):
			var card = cardbase.instantiate()
			card.card = DatabaseService.get_card(el[1])
			card.is_enable = false
			match int(el[0]):
				1: $EnemySlots/Slot2.add_child(card)
				2: $EnemySlots/Slot1.add_child(card)
				3: $EnemySlots/Slot4.add_child(card)
				4: $EnemySlots/Slot3.add_child(card)
				5: $EnemySlots/Slot6.add_child(card)
				6: $EnemySlots/Slot5.add_child(card)
		var player_slots = $PlayerSlots.get_children()
		var enemy_slots = $EnemySlots.get_children()
		for i in enemy_slots.size():
			if enemy_slots[i].get_child_count() != 0:
				var card = enemy_slots[i].get_child(0)
				card.position.x -= 20
				if i in [0, 1]:
					if player_slots[1].get_child_count():
						player_slots[1].get_child(0).get_damage(card.deal_damage())
					elif player_slots[0].get_child_count():
						player_slots[0].get_child(0).get_damage(card.deal_damage())
					else:
						player_hero.change_hp(-card.card.attack)
				elif i in [2, 3]:
					if player_slots[3].get_child_count():
						player_slots[3].get_child(0).get_damage(card.deal_damage())
					elif player_slots[2].get_child_count():
						player_slots[2].get_child(3).get_damage(card.deal_damage())
					else:
						player_hero.change_hp(-card.card.attack)
				elif i in [4, 5]:
					if player_slots[5].get_child_count():
						player_slots[5].get_child(0).get_damage(card.deal_damage())
					elif player_slots[4].get_child_count():
						player_slots[4].get_child(3).get_damage(card.deal_damage())
					else:
						player_hero.change_hp(-card.card.attack)
				await get_tree().create_timer(0.5).timeout
				card.position.x += 20
		$Button.disabled = false
		for card in $Hand.get_children():
			card.is_enable2 = true
		draw_card()
		if int(max_mana_label.text) != 10:
			max_mana_label.text = str(int(max_mana_label.text) + 1)
		cur_mana_label.text = max_mana_label.text

func joined():
	host.hide()
	join.hide()
	username.hide()
	usrname = username.text
	cur_mana_label.text = '3'
	max_mana_label.text = '3'

func draw_card():
	if deck_index != deck.size() - 1:
		var card = cardbase.instantiate()
		card.card = deck[deck_index]
		card.is_enable = false
		deck_index += 1
		$Hand.add_child(card)
	

func _on_popup_popup_hide():
	get_tree().change_scene_to_file("res://scenes/node_2d.tscn")
