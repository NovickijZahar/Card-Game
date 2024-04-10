extends Node2D

const card_base = preload('res://scenes/card_base.tscn')
var cardDatabase
var card_size = Vector2(125, 175)
@onready var matrix = [[$Board/Slot1, $Board/Slot2, $Board/Slot3, $Board/Slot4, $Board/Slot5],
[$Board/Slot6, $Board/Slot7, $Board/Slot8, $Board/Slot9, $Board/Slot10],
[$Board/Slot11, $Board/Slot12, $Board/Slot13, $Board/Slot14, $Board/Slot15],
[$Board/Slot16, $Board/Slot17, $Board/Slot18, $Board/Slot19, $Board/Slot20]]


func _ready():
	cardDatabase = CardDataBase.get_instance()
	
	var ecard1 = card_base.instantiate()
	ecard1.card = cardDatabase.data[0]
	matrix[1][0].add_child(ecard1)
	
	var ecard2 = card_base.instantiate()
	ecard2.card = cardDatabase.data[1]
	matrix[1][2].add_child(ecard2)
	
	var pcard1 = card_base.instantiate()
	pcard1.card = cardDatabase.data[1]
	matrix[2][2].add_child(pcard1)
	
	var pcard2 = card_base.instantiate()
	pcard2.card = cardDatabase.data[2]
	matrix[2][0].add_child(pcard2)



func _on_end_turn_pressed():
	#matrix[1][2].remove_child(matrix[1][2].get_child(1))
	$EndTurn.disabled = true
	for i in range(2, 4):
		for j in range(5):
			if matrix[i][j].get_child_count() == 2:
				matrix[i][j].get_child(1).position.y -= 10
				await get_tree().create_timer(0.3).timeout
				matrix[i][j].get_child(1).position.y += 10
				if matrix[i - 1][j].get_child_count() == 2 and matrix[i - 1][j].get_child(1).\
					get_damage(matrix[i][j].get_child(1).deal_damage()):
						await get_tree().create_timer(0.3).timeout
						matrix[i - 1][j].remove_child(matrix[i - 1][j].get_child(1))
				await get_tree().create_timer(0.3).timeout
	$TurnLabel.text = 'Ход противника'
	for i in range(0, 2):
		for j in range(5):
			if matrix[i][j].get_child_count() == 2:
				matrix[i][j].get_child(1).position.y += 10
				await get_tree().create_timer(0.3).timeout
				matrix[i][j].get_child(1).position.y -= 10
				if matrix[i + 1][j].get_child_count() == 2 and matrix[i + 1][j].get_child(1).\
					get_damage(matrix[i][j].get_child(1).deal_damage()):
						await get_tree().create_timer(0.3).timeout
						matrix[i + 1][j].remove_child(matrix[i + 1][j].get_child(1))
				await get_tree().create_timer(0.3).timeout
	$TurnLabel.text = 'Ваш ход'
	$EndTurn.disabled = false
	$EndTurn.release_focus()



func _on_exit_button_pressed():
	get_tree().change_scene_to_file("res://scenes/node_2d.tscn")
	
