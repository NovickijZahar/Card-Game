extends MarginContainer

var cardDatabase = CardDataBase.get_instance()
var card = cardDatabase.data[0]


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


func get_manacost() -> int:
	return int($Bars/TopBar/ManaBar/ManaLabel.text)


var dragable = false
var is_inside_dropable = false
var body_ref
var offset: Vector2
var initial_position: Vector2


func _process(delta):
	if dragable:
		if Input.is_action_just_pressed("click"):
			initial_position = position
			offset = get_global_mouse_position() - position
			Global.is_dragging = true
		if Input.is_action_pressed("click"):
			position = get_global_mouse_position() - offset
		elif Input.is_action_just_released("click"):
			Global.is_dragging = false
			var tween = get_tree().create_tween()
			if is_inside_dropable:
				is_played = true
				body_ref.occupied = true
				body_ref.card_base = self
				tween.tween_property(self, "position", body_ref.position, 
				0).set_ease(Tween.EASE_OUT)
			else:
				tween.tween_property(self, "position", initial_position, 
				0).set_ease(Tween.EASE_OUT)
	if is_replace:
		Global.selected_card = self

var is_played: bool = false
var enough_mana: bool = true
var is_enable: bool = true
var is_replace: bool = false

func _on_area_2d_body_entered(body):
	if body.is_in_group('dropable') and !body.occupied:
		is_inside_dropable = true
		body.modulate = Color(Color.REBECCA_PURPLE, 1)
		body_ref = body


func _on_area_2d_body_exited(body):
	if body.is_in_group('dropable'):
		if body != body_ref:
			is_inside_dropable = true
		else:
			is_inside_dropable = false
		body.modulate = Color(Color.MEDIUM_PURPLE, 0.7)


func _on_area_2d_mouse_entered():
	if !Global.is_dragging and !is_played and enough_mana and is_enable:
		dragable = true
		scale = Vector2(1.05, 1.05)
	is_replace = true


func _on_area_2d_mouse_exited():
	if !Global.is_dragging:
		dragable = false
		scale = Vector2(1, 1)
	is_replace = false
