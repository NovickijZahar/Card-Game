class_name Boss

extends Hero

var feature: String
var icon_path: String

func _init(name, image_name, deck, hp, feature, icon_path):
	super._init(name, image_name, deck, hp)
	self.feature = feature
	self.image_name = str('res://src/boss_arts/', image_name)
	self.icon_path = str('res://src/boss_icons/', icon_path)
