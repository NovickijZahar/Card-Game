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
		data[cards.Dragon],
		data[cards.DemonKnight]
	]

func replace(old_card, new_card):
	for i in range(card_arr.size()):
		if old_card == card_arr[i]:
			card_arr[i] = new_card
			break


static func get_instance():
	if instance == null:
		instance = Deck.new()
	return instance
