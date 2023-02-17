extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(0);
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_RestartButton_button_up():
	get_tree().change_scene("res://Main.tscn")
