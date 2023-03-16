extends Sprite


func _on_InventoryArea_body_entered(body):
	print(str('Body entered: ', body.get_name()))
	body.within_inventory = true
	body.currentLocation = self
	
	
func _on_InventoryArea_body_exited(body):
	body.within_inventory  = false
