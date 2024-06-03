extends Node2D

@onready var container = $HBoxContainer
@onready var card_base = preload("res://scenes/card_base.tscn")
var selected_card


func _ready():
	$Background.texture = load("res://src/background_arts/" + str(DatabaseService.get_current_room()) + ".jpg")
	$Background.scale *= get_viewport().get_visible_rect().size / $Background.texture.get_size()
	
	var all_cards = DatabaseService.get_all_cards(true)
	randomize()
	all_cards.shuffle()
	var i = 0
	for card in all_cards:
		var c = card_base.instantiate()
		c.card = card
		c.is_enable = false
		container.add_child(c)
		i += 1
		if i == 2:
			break


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.selected_card != null:
		if selected_card != null:
			selected_card.get_child(0).get_child(0).visible = false
		selected_card = Global.selected_card
		selected_card.get_child(0).get_child(0).visible = true


func _on_choose_button_pressed():
	if selected_card != null:
		DatabaseService.add_to_colletion(selected_card.card.name)
		$Popup/CenterContainer/Label.text = 'Вы получили ' + selected_card.card.name
		$Popup.popup(Rect2i(500, 300, 920, 460))
	if container.get_children().size() == 0:
		$Popup/CenterContainer/Label.text = 'У вас уже есть все карты в коллекции'
		$Popup.popup(Rect2i(500, 300, 920, 460))


func _on_popup_popup_hide():
	get_tree().change_scene_to_file("res://scenes/map.tscn")
