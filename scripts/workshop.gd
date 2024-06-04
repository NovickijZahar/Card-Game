extends Node2D

@onready var workshop_lot = preload("res://scenes/work_shop_lot.tscn")
@onready var container = $ScrollContainer/HBoxContainer
var selected_card
var selected_price
var selected_feature
var selected_workshoplot

func _ready():
	$Background.texture = load("res://src/background_arts/" + str(DatabaseService.get_current_room()) + ".jpg")
	$Background.scale *= get_viewport().get_visible_rect().size / $Background.texture.get_size()
	$DataContainer/Label2.text = str(DatabaseService.get_money()) + '$'
	var all_cards = DatabaseService.get_collection()
	all_cards.shuffle()
	var i = 0
	for card in all_cards:
		var c = workshop_lot.instantiate()
		c.card = card
		c.is_enable = false
		c.get_child(3).get_child(5).get_child(1).text = str(randi_range(100, 150))
		var feats = [1, 2, 3, 4, 5]
		for f in JSON.parse_string(c.card.description):
			feats.erase(int(f))
		if feats.size() <= 2:
			continue
		var rand_feat = feats.pick_random()
		c.get_child(3).get_child(4).get_child(1).text = str(DatabaseService.get_features([rand_feat], true))
		c.get_child(3).get_child(4).tooltip_text = DatabaseService.get_features_tooltip([rand_feat])
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
		if c == selected_card:
			selected_price = int(c.get_child(3).get_child(5).get_child(1).text)
			selected_workshoplot = c
			selected_feature = c.get_child(3).get_child(4).get_child(1).text.strip_edges()
			if DatabaseService.get_money() < selected_price:
				selected_card.get_child(0).get_child(0).color = Color('ff301a')


func _on_return_button_pressed():
	get_tree().change_scene_to_file("res://scenes/map.tscn")



func _on_buy_button_pressed():
	if selected_card != null and selected_price != null:
		if DatabaseService.get_money() >= selected_price:
			DatabaseService.add_feature_to_card(selected_card.card.name, selected_feature)
			DatabaseService.add_money(-selected_price)
			container.remove_child(selected_workshoplot)
			$DataContainer/Label2.text = str(DatabaseService.get_money()) + '$'
			$Popup/CenterContainer/Label.text = 'Вы добавили свойство ' + selected_feature + ' к карте '+selected_card.card.name + '\nза ' + str(selected_price) + '$'
			$Popup.popup(Rect2i(500, 300, 920, 460))
		else:
			$Popup/CenterContainer/Label.text = 'Недостаточно денег'
			$Popup.popup(Rect2i(500, 300, 920, 460))
