extends Camera2D

var zoom_min = Vector2(0.2, 0.2)
var zoom_max = Vector2(1.6, 1.6)
var zoom_speed = Vector2(0.2, 0.2)

var is_mouse_dragging = false
var start_position: Vector2
var end_poisition: Vector2
var offset_speed = 3

var mouse_position: Vector2

@onready var enter_button = $EnterButton


func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				if zoom > zoom_min:
					zoom -= zoom_speed
					
			elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
				if zoom < zoom_max:
					zoom += zoom_speed
					
					
					
#			elif event.button_index == MOUSE_BUTTON_RIGHT:
#					is_mouse_dragging = true
#					start_position = event.global_position
		#else:
			#is_mouse_dragging = false
	#if event is InputEventMouseMotion and is_mouse_dragging:
		#end_poisition = event.global_position
func _process(delta):
	enter_button.scale = Vector2(1 / zoom.x, 1 / zoom.y)
	enter_button.position = Vector2(700, 10) - Vector2(200, 100) * zoom  # Позиция кнопки зависит от zoom
#func _physics_process(delta):
#	if is_mouse_dragging:
#		offset -= delta * offset_speed * (end_poisition - start_position) / zoom
