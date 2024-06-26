extends Node2D

@onready var deck_grid = $ScrollContainer/DeckContainer
@onready var collection_grid = $ScrollContainer2/CollectionContainer
const card_base = preload('res://scenes/card_base.tscn')
var deck
var collection
var deck_card = null
var collection_card = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$Background.texture = load("res://src/book.jpg")
	$Background.scale *= get_viewport().get_visible_rect().size / $Background.texture.get_size()
	
	var deck = DatabaseService.get_deck()
	for c in deck:
		var card = card_base.instantiate()
		card.card = c
		card.is_enable = false
		deck_grid.add_child(card) 
	var collection = DatabaseService.get_collection(true)
	for c in collection:
		var card = card_base.instantiate()
		card.card = c
		card.is_enable = false
		collection_grid.add_child(card) 

func _process(delta):
	if Global.selected_card != null:
		if Global.selected_card in deck_grid.get_children():
			if deck_card != null:
				deck_card.get_child(0).get_child(0).visible = false
			deck_card = Global.selected_card
			deck_card.get_child(0).get_child(0).visible = true 
		elif Global.selected_card in collection_grid.get_children():
			if collection_card != null:
				collection_card.get_child(0).get_child(0).visible = false
			collection_card = Global.selected_card
			collection_card.get_child(0).get_child(0).visible = true 


func _on_change_button_pressed():
	if deck_card != null and collection_card != null:
		var index1 = 0
		var index2 = 0
		for i in range(deck_grid.get_children().size()):
			if deck_grid.get_child(i) == deck_card:
				index1 = i
		for i in range(collection_grid.get_children().size()):
			if collection_grid.get_child(i) == collection_card:
				index2 = i

		collection_card.get_child(0).get_child(0).visible = false
		deck_card.get_child(0).get_child(0).visible = false

		deck_grid.remove_child(deck_card)
		collection_grid.add_child(deck_card)

		collection_grid.remove_child(collection_card)
		deck_grid.add_child(collection_card)

		DatabaseService.replace_in_deck(deck_card.card.name, collection_card.card.name)

		collection_grid.move_child(deck_card, index2)
		deck_grid.move_child(collection_card, index1)

		collection_card.get_child(0).get_child(0).visible = false
		deck_card.get_child(0).get_child(0).visible = false

		Global.selected_card = null
		deck_card.get_child(0).get_child(0).visible = false
		collection_card.get_child(0).get_child(0).visible = false
		collection_card = null
		deck_card = null
	


func _on_exit_button_pressed():
	get_tree().change_scene_to_file("res://scenes/map.tscn")
