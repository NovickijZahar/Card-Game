class_name CardDataBase

static var instance = null
var data: Dictionary

enum Cards
{
	Killer, Warrior, ShadowWarrior
}

func _init():
	data = {
		Cards.Killer: MinionCard.new('Killer', 'Deal a great damage', 'Killer.png', AbstractCard.Rarity.Common, 2, 5, 1),
		Cards.Warrior: MinionCard.new('Warrior', 'Nothing', 'Warrior.png', AbstractCard.Rarity.Rare, 2, 3, 4),
		Cards.ShadowWarrior: MinionCard.new('MrShadow', 'MrShadow', 'preview.webp',AbstractCard.Rarity.Epic, 5, 7, 7),
}

static func get_instance():
	if instance == null:
		instance = CardDataBase.new()
	return instance

