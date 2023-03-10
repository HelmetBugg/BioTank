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
		if !$InventoryContainer.visible:
			$InventoryContainer.visible = true
			Input.set_mouse_mode(0);
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			$InventoryContainer.visible = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		if enemyInventoryInRange and !currentInRangeEnemy == null:
			$InventoryContainer/EnemyGrid.visible = !$InventoryContainer/EnemyGrid.visible
			#print(currentInRangeEnemy.get_parent().inventory)
			var item1 = item.instance()
			var inventory = currentInRangeEnemy.get_parent().inventory
			item1.get_node("Sprite").texture=load(inventory[0])
			$InventoryContainer/EnemyGrid.add_child(item1)
	velocity.y = vy


func kill():
	if killable:
		get_tree().change_scene("res://DeadScreen.tscn")


func _on_PlayerReach_area_entered(area):
	if area.get_name() == 'EnemyRange':
		enemyInventoryInRange = true
		currentInRangeEnemy = area


func _on_PlayerReach_area_exited(area):
	if area.get_name() == 'EnemyRange':
		enemyInventoryInRange = false
		currentInRangeEnemy = null
