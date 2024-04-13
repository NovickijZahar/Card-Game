class_name Collection

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
		data[cards.DemonKnight],
		data[cards.DragonBaby],
		data[cards.Druid]
	]

func add_card(card):
	card_arr.append(card)


static func get_instance():
	if instance == null:
		instance = Collection.new()
	return instance
