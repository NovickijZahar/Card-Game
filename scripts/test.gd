extends Node2D


@onready var slots = [[$CardSlot, $CardSlot2, $CardSlot3], 
					[$CardSlot3, $CardSlot4, $CardSlot4]]
var cards = []


var data
const card_base = preload('res://scenes/card_base.tscn')

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var deck = Deck.get_instance()
	data = deck.card_arr.duplicate()
	data.shuffle()
	
	var card1 = card_base.instantiate()
	card1.card = data[0]
	add_child(card1)
	card1.position = Vector2(650, 800)
	
	var card2 = card_base.instantiate()
	card2.card = data[1]
	add_child(card2)
	card2.position = Vector2(800, 800)
	


func _on_end_turn_pressed():
	var card3 = card_base.instantiate()
	card3.card = data[2]
	add_child(card3)
	card3.position = Vector2(1400, 400)
	var tween = get_tree().create_tween()
	tween.tween_property(card3, "position", Vector2(950, 800), 0.5)
	$EndTurn.release_focus()
