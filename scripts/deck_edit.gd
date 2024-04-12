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
	deck = Deck.get_instance()
	for data in deck.card_arr:
		var card = card_base.instantiate()
		card.card = data
		card.is_enable = false
		deck_grid.add_child(card)
		
	collection = CardDataBase.get_instance()
	for data in collection.data.values():
		var flag = true
		for c in deck.card_arr:
			if data == c:
				flag = false
				break
		if flag:
			var card = card_base.instantiate()
			card.card = data
			card.is_enable = false
			collection_grid.add_child(card)

func _process(delta):
	if Global.selected_card != null:
		if Global.selected_card in deck_grid.get_children():
			deck_card = Global.selected_card 
		elif Global.selected_card in collection_grid.get_children():
			collection_card = Global.selected_card


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
		
		deck_grid.remove_child(deck_card)
		collection_grid.add_child(deck_card)
		
		collection_grid.remove_child(collection_card)
		deck_grid.add_child(collection_card)

		deck.replace(deck_card.card, collection_card.card)
		
#		collection_grid.move_child(deck_card, index1 - 1)
#		deck_grid.move_child(collection_card, index2 - 1)
		
		collection_card = null
		deck_card = null
	
	
	
#	var first = Global.selected_card
#	first.get_parent().remove_child(first)
#	collection_grid.add_child(first)
#	first.get_parent().move_child(first, 0)
	
#	var second = collection_grid.get_child(0)
#	second.get_parent().remove_child(second)
#	deck_grid.add_child_below_node(second)


func _on_exit_button_pressed():
	
	get_tree().change_scene_to_file("res://scenes/node_2d.tscn")