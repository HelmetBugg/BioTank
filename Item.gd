extends KinematicBody2D

var original_position = Vector2()
var dragging = false
var within_inventory = false
var currentLocation = null

func _process(delta):
	if dragging:
		self.global_position = get_global_mouse_position()


func _on_Item_input_event2(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			original_position = self.global_position
			dragging = true
		elif event.button_index == BUTTON_LEFT and !event.pressed:
			dragging = false
			if !within_inventory: 
				# Reset position.
				self.global_position = original_position
			else:
				get_parent().remove_child(self)
				currentLocation.add_child(self)
				self.global_position = get_global_mouse_position()
