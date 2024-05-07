extends Node

var is_dragging = false

var selected_card = null

var money = 100
var experience = 0
var map_position: Vector2
var completed_events: Array[Vector2]

var LVL = {
	1000: 1,
	2000: 2,
}

func lvl():
	return int(experience / 1000)
