class_name Deck

var cards = []

static var instance = null
var card_arr: Array
var cardDatabase

func _init():
	cardDatabase = CardDataBase.get_instance()
	var cards = cardDatabase.Cards
	var data = cardDatabase.data
	card_arr = [
		data[cards.Killer],
		data[cards.Warrior],
		data[cards.ShadowWarrior],
		data[cards.Dragon],
		data[cards.Spirit]
	]

func replace(old_card, new_card):
	for card in card_arr:
		if old_card == card:
			old_card = new_card
			break


static func get_instance():
	if instance == null:
		instance = Deck.new()
	return instance
