class_name Hero

var name: String
var image_name: String
var deck: Array
var hp: int

func _init(name, image_name, deck, hp):
	self.name = name
	self.image_name = str('res://src/hero_arts/', image_name)
	self.deck = deck
	self.hp = hp 
