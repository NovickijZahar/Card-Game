class_name Boss

extends Hero

var feature: String

func _init(name, image_name, deck, hp, feature):
	super._init(name, image_name, deck, hp)
	self.feature = feature
	self.image_name = str('res://src/boss_arts/', image_name)
