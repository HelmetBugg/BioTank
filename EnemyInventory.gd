extends Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_InventoryArea_body_entered(body):
	print(str('Body entered: ', body.get_name()))
	body.within_inventory  = true
	
	
func _on_InventoryArea_body_exited(body):
	body.within_inventory  = false
