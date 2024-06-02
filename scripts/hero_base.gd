extends MarginContainer

var hero = DatabaseService.get_hero(1)
@onready var hp = $VBoxContainer/HBoxContainer/MarginContainer2/HpLabel

func _ready():
	$Art.texture = load(hero.image_name)
	$Art.scale *= custom_minimum_size / $Art.texture.get_size()
	hp.text = str(hero.hp)
	$VBoxContainer/HBoxContainer/MarginContainer/NameLabel.text = hero.name

func change_hero(new_hero):
	hero = new_hero
	$Art.texture = load(new_hero.image_name)
	$Art.scale = Vector2(1, 1)
	$Art.scale *= custom_minimum_size / $Art.texture.get_size()
	hp.text = str(new_hero.hp)
	$VBoxContainer/HBoxContainer/MarginContainer/NameLabel.text = new_hero.name

func change_hp(diff):
	$Node2D.visible = true
	if diff > 0:
		$Node2D/Label.text = '+' + str(diff)
	elif diff < 0:
		$Node2D/Label.text = str(diff)
	await get_tree().create_timer(1).timeout
	$Node2D.visible = false
	hp.text = str(int(hp.text) + diff)
	
func get_hp():
	return int(hp.text)

func _process(delta):
	if int(hp.text) < hero.hp:
		hp.modulate = Color(1, 0, 0)
	else:
		hp.modulate = Color(0.258, 0.553, 0)
		
