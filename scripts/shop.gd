extends Node2D

@onready var card_lot = preload("res://scenes/card_lot.tscn")
@onready var container = $ScrollContainer/HBoxContainer
var collection
var card_database
var selected_card
var selected_price
var selected_lot


func _ready():
	$DataContainer/Label2.text = str(Global.money) + '$'
	collection = Collection.get_instance()
	card_database = CardDataBase.get_instance().data.values()
	card_database.shuffle()
	var i = 0
	for card in card_database:
		if card not in collection.card_arr:
			var c = card_lot.instantiate()
			c.get_child(0).card = card
			c.get_child(0).is_enable = false
			c.get_child(0).get_child(4).get_child(1).get_child(1).text = str(randi_range(50, 150))
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
			selected_price = int(c.get_child(0).get_child(4).get_child(1).get_child(1).text)
			selected_lot = c
			if Global.money < selected_price:
				selected_card.get_child(0).get_child(0).color = Color('ff301a')



func _on_return_button_pressed():
	get_tree().change_scene_to_file("res://scenes/map.tscn")



func _on_buy_button_pressed():
	if selected_card != null and selected_price != null:
		if Global.money >= selected_price:
			collection.add_card(selected_card.card)
			Global.money -= selected_price
			container.remove_child(selected_lot)
			$DataContainer/Label2.text = str(Global.money) + '$'
			$Popup/CenterContainer/Label.text = 'Вы приобрели ' + selected_card.card.name + '\nза ' + str(selected_price) + '$'
			$Popup.popup(Rect2i(500, 300, 920, 460))
		else:
			$Popup/CenterContainer/Label.text = 'Недостаточно денег'
			$Popup.popup(Rect2i(500, 300, 920, 460))
