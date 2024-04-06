class_name Hand

var cards = []

func _init(cards):
	pass

func draw_card(card):
	cards.append(card)

func play_card(card):
	cards.erase(card)
