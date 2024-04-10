extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	modulate = Color(Color.MEDIUM_PURPLE, 0.7)

var occupied = false

func _process(delta):
	if Global.is_dragging and !occupied:
		visible = true
	else:
		visible = false
