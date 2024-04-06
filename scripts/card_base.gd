extends MarginContainer

var cardDatabase = CardDataBase.get_instance()
var card = cardDatabase.data[0]
var attack
var hp

func _ready():
	var CardSize = custom_minimum_size
	$Border.scale *= CardSize / $Border.texture.get_size()
	$Card.texture = load(card.image_name)
	$Card.scale *= CardSize / $Card.texture.get_size()
	$Card.scale.y = 0.1
	$Bars/BottomBar/AttackBar/AttackLabel.text = str(card.attack)
	$Bars/BottomBar/HpBar/HpLabel.text = str(card.hp)
	$Bars/BottomBar/NameBar/NameLabel.text = card.name
	$Bars/DescrBar/DescrLabel.text = card.description
	$Bars/TopBar/ManaBar/ManaLabel.text = str(card.manacost)

func get_damage(damage) -> bool:
	$Bars/BottomBar/HpBar/HpLabel.text = \
		str(int($Bars/BottomBar/HpBar/HpLabel.text) - damage)
	if int($Bars/BottomBar/HpBar/HpLabel.text) <= 0:
		return true
	return false
	
func deal_damage() -> int:
	return int($Bars/BottomBar/AttackBar/AttackLabel.text)
