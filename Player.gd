extends KinematicBody

export var gravity = Vector3.DOWN * 10
export var speed = 4
export var rot_speed = 0.85
onready var raycast = $Pivot/TankTop/RayCast
const Bullet = preload("res://Bullet.tscn")
var velocity = Vector3.ZERO
var enemyInventoryInRange = false
var killable = false
var currentInRangeEnemy = null
const item = preload("res://Item.tscn")
var inventory = []


func _ready():
	$InventoryContainer.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	yield(get_tree(), "idle_frame")
	get_tree().call_group("enemies", "set_player", self)


func _physics_process(delta):
	velocity += gravity * delta
	get_input(delta)
	velocity = move_and_slide(velocity, Vector3.UP)


func get_input(delta):
	var vy = velocity.y
	velocity = Vector3.ZERO
	if Input.is_action_pressed("forward"):
		velocity += -transform.basis.z * speed
	if Input.is_action_pressed("reverse"):
		velocity += transform.basis.z * speed
	if Input.is_action_pressed("turn_right"):
		rotate_y(-rot_speed * delta)
	if Input.is_action_pressed("turn_left"):
		rotate_y(rot_speed * delta)
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_pressed("fire"):
		var coll = raycast.get_collider()
		if raycast.is_colliding() and coll.has_method("kill"):
			coll.kill()
	if Input.is_action_just_pressed("inventory_toggle"):
		toggleInventory()
	velocity.y = vy


func toggleInventory():
	# Open Inventory	
	if !$InventoryContainer.visible:
		displayPlayerInventory()
		$InventoryContainer.visible = true
		Input.set_mouse_mode(0);
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if enemyInventoryInRange and !currentInRangeEnemy == null:
			displayEnemyInventory()
		
	# Close Inventory
	else:
		$InventoryContainer.visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		closeInventory(self, $InventoryContainer/PlayerInventory/PlayerInventoryArea)
		if enemyInventoryInRange and !currentInRangeEnemy == null:
			closeInventory(currentInRangeEnemy.get_parent(), $InventoryContainer/EnemyInventory/InventoryArea)


func displayPlayerInventory():
	displayInventory(self.inventory)


func displayEnemyInventory():
	displayInventory(currentInRangeEnemy.get_parent().inventory)
	$InventoryContainer/EnemyInventory.visible = !$InventoryContainer/EnemyInventory.visible


func displayInventory(inventory):
	var spawned_items = []	
	var i = 0
	while i < inventory.size():
		spawned_items.push_back(item.instance())
		spawned_items[i].get_node("Sprite").texture = load(inventory[i])
		$InventoryContainer/EnemyInventory.add_child(spawned_items[i])
		spawned_items[i].position.y = 100
		spawned_items[i].position.x = 50 + spawned_items[i].position.x + (50 * i)
		i += 1


func closeInventory(owner, inventoryContainer):
	owner.inventory.clear()
	for item in inventoryContainer.get_overlapping_bodies():
		if item.get_parent().get_node("Sprite"):
			owner.inventory.push_back(item.get_parent().get_node("Sprite").texture)
			item.queue_free()


func kill():
	if killable:
		get_tree().change_scene("res://DeadScreen.tscn")


func _on_PlayerReach_area_entered(area):
	if area.get_name() == 'EnemyRange' and area.get_parent().dead:
		enemyInventoryInRange = true
		currentInRangeEnemy = area


func _on_PlayerReach_area_exited(area):
	if area.get_name() == 'EnemyRange' and area.get_parent().dead:
		enemyInventoryInRange = false
		currentInRangeEnemy = null
