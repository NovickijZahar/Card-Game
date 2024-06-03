extends Node2D

@onready var card_lot = preload("res://scenes/card_lot.tscn")
@onready var container = $ScrollContainer/HBoxContainer
var collection
var card_database
var selected_card
var selected_price
var selected_lot


func _ready():
	$Background.texture = load("res://src/background_arts/" + str(DatabaseService.get_current_room()) + ".jpg")
	$Background.scale *= get_viewport().get_visible_rect().size / $Background.texture.get_size()
	
	$DataContainer/Label2.text = str(DatabaseService.get_money()) + '$'
	var all_cards = DatabaseService.get_all_cards(true)
	all_cards.shuffle()
	var i = 0
	for card in all_cards:
		var c = card_lot.instantiate()
		c.get_child(0).card = card
		c.get_child(0).is_enable = false
		c.get_child(0).get_child(5).get_child(1).get_child(1).text = str(randi_range(50, 150))
		container.add_child(c)
		i += 1
		if i == 2:
			break

func _process(delta):
	if Global.selected_card != null:
		if selected_card != null:
			selected_card.get_child(0).get_child(0).visible = false
			selected_card.get_child(0).get_child(0).color = Color('5bae83')
		selected_card = Global.selected_card
		selected_card.get_child(0).get_child(0).visible = true
	for c in container.get_children():
		if c.get_child(0) == selected_card:
			selected_price = int(c.get_child(0).get_child(5).get_child(1).get_child(1).text)
			selected_lot = c
			if DatabaseService.get_money() < selected_price:
				selected_card.get_child(0).get_child(0).color = Color('ff301a')



func _on_return_button_pressed():
	get_tree().change_scene_to_file("res://scenes/map.tscn")



func _on_buy_button_pressed():
	if selected_card != null and selected_price != null:
		if DatabaseService.get_money() >= selected_price:
			DatabaseService.add_to_colletion(selected_card.card.name)
			DatabaseService.add_money(-selected_price)
			container.remove_child(selected_lot)
			$DataContainer/Label2.text = str(DatabaseService.get_money()) + '$'
			$Popup/CenterContainer/Label.text = 'Вы приобрели ' + selected_card.card.name + '\nза ' + str(selected_price) + '$'
			$Popup.popup(Rect2i(500, 300, 920, 460))
		else:
			$Popup/CenterContainer/Label.text = 'Недостаточно денег'
			$Popup.popup(Rect2i(500, 300, 920, 460))
