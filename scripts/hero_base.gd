extends MarginContainer

var hero = DatabaseService.get_hero(1)
@onready var hp = $VBoxContainer/HBoxContainer/MarginContainer2/HpLabel

func _ready():
	var art_size = custom_minimum_size
	$Art.texture = load(hero.image_name)
	$Art.scale *= art_size / $Art.texture.get_size()
	hp.text = str(hero.hp)
	$VBoxContainer/HBoxContainer/MarginContainer/NameLabel.text = hero.name

func change_hero(new_hero):
	hero = new_hero
	$Art.texture = load(new_hero.image_name)
	hp.text = str(new_hero.hp)
	$VBoxContainer/HBoxContainer/MarginContainer/NameLabel.text = new_hero.name

func change_hp(diff):
	hp.text = str(int(hp.text) + diff)
	
func get_hp():
	return int(hp.text)

func _process(delta):
	if int(hp.text) < hero.hp:
		hp.modulate = Color(1, 0, 0)
	else:
		hp.modulate = Color(0.258, 0.553, 0)
		
