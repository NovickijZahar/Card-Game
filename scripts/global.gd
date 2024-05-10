extends Node

var is_dragging = false

var selected_card = null

var money = 100
var experience = 0
var map_position: Vector2
var completed_events: Array[Vector2]
var uncompleted_events = {}

var path_to_file = 'user://save1.cfg'
var path_to_file2 = 'user://save2.cfg'

var LVL = {
	1000: 1,
	2000: 2,
}

func save_data():
	var config = ConfigFile.new()
	config.load(path_to_file)
	config.set_value('Player', 'money', money)
	config.set_value('Player', 'experience', experience)
	config.set_value('Player', 'map_position', map_position)
	config.set_value('Map', 'completed_events', completed_events)
	config.set_value('Map', 'uncompleted_events', uncompleted_events)
	config.save(path_to_file)
	
func load_data():
	var config = ConfigFile.new()
	if config.load(path_to_file) == OK:
		money = config.get_value('Player', 'money')
		experience = config.get_value('Player', 'experience')
		map_position = config.get_value('Player', 'map_position')
		completed_events = config.get_value('Map', 'completed_events')
		uncompleted_events = config.get_value('Map', 'uncompleted_events')
