extends Node2D

@onready var container = $HBoxContainer
@onready var card_base = preload("res://scenes/card_base.tscn")
var collection
var card_database
var selected_card

# Called when the node enters the scene tree for the first time.
func _ready():
	collection = Collection.get_instance()
	card_database = CardDataBase.get_instance().data.values()
	randomize()
	card_database.shuffle()
	var i = 0
	for card in card_database:
		if card not in collection.card_arr:
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
		collection.add_card(selected_card.card)
		get_tree().change_scene_to_file("res://scenes/map.tscn")
