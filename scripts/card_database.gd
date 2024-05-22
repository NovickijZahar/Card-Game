class_name CardDataBase

static var instance = null
var data: Dictionary

enum Cards
{
	Killer = 1, 
	Warrior, 
	Spirit, 
	ShadowWarrior, 
	Dragon, 
	DragonBaby,
	Druid,
	Lion,
	Owl,
	DemonKnight
}

func _init():
	data = {
		Cards.Killer: MinionCard.new('Killer', 'Deal a great damage', 'Killer.png', AbstractCard.Rarity.Common, 2, 5, 1),
		Cards.Warrior: MinionCard.new('Warrior', 'Nothing', 'Warrior.png', AbstractCard.Rarity.Rare, 2, 3, 4),
		Cards.Spirit: MinionCard.new('Spirit', '', 'Spirit.webp', AbstractCard.Rarity.Epic, 5, 7, 7),
		Cards.ShadowWarrior: MinionCard.new('Shadow', '', 'ShadowWarrior.png', AbstractCard.Rarity.Rare, 6, 6, 6),
		Cards.Dragon: MinionCard.new('Dragon', '', 'Dragon.webp', AbstractCard.Rarity.Legendary, 8, 10, 10),
		Cards.DragonBaby: MinionCard.new('Baby dragon', '', 'DragonBaby.webp', AbstractCard.Rarity.Common, 1, 1, 2),
		Cards.Druid: MinionCard.new('Druid', '', 'Druid.webp', AbstractCard.Rarity.Rare, 2, 3, 2),
		Cards.Lion: MinionCard.new('Lion', '', 'Lion.webp', AbstractCard.Rarity.Rare, 4, 4, 4),
		Cards.Owl: MinionCard.new('Owl', '', 'Owl.webp', AbstractCard.Rarity.Common, 1, 2, 1),
		Cards.DemonKnight: MinionCard.new('Demon', '', 'DemonKnight.webp', AbstractCard.Rarity.Epic, 3, 4, 3),
}

static func get_instance():
	if instance == null:
		instance = CardDataBase.new()
	return instance

