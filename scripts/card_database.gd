class_name CardDataBase

static var instance = null
var data: Dictionary

enum Cards
{
	Killer, Warrior, Spirit, ShadowWarrior, Dragon
}

func _init():
	data = {
		Cards.Killer: MinionCard.new('Killer', 'Deal a great damage', 'Killer.png', AbstractCard.Rarity.Common, 2, 5, 1),
		Cards.Warrior: MinionCard.new('Warrior', 'Nothing', 'Warrior.png', AbstractCard.Rarity.Rare, 2, 3, 4),
		Cards.Spirit: MinionCard.new('Spirit', '123', 'Spirit.webp', AbstractCard.Rarity.Epic, 5, 7, 7),
		Cards.ShadowWarrior: MinionCard.new('Shadow', '456', 'ShadowWarrior.png', AbstractCard.Rarity.Rare, 6, 6, 6),
		Cards.Dragon: MinionCard.new('Dragon', '789', 'Dragon.webp', AbstractCard.Rarity.Legendary, 8, 10, 10),
}

static func get_instance():
	if instance == null:
		instance = CardDataBase.new()
	return instance

