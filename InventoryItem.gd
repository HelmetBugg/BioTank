extends KinematicBody2D

var grabbed_offset = Vector2()
var original_position = Vector2()
var dragging = false

func _process(delta):
	if dragging:
		var mousepos = get_viewport().get_mouse_position()
		position = get_global_mouse_position() + grabbed_offset
		

func _on_ItemBody_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		print("ME!!!")
		if event.button_index == BUTTON_LEFT and event.pressed:
			grabbed_offset = position - get_global_mouse_position()
			original_position = position
			dragging = true

		elif event.button_index == BUTTON_LEFT and !event.pressed:
			position = original_position
			dragging = false
