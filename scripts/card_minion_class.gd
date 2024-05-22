class_name MinionCard

extends AbstractCard

var attack: int
var hp: int

func _init(name, description, image_name, rarity, manacost, attack, hp):
	self.name = name
	self.description = description
	self.rartity  = rarity
	self.manacost = manacost
	self.attack = attack
	self.hp = hp
	self.image_name = str('res://src/card_arts/minion/', image_name)

