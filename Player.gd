extends KinematicBody

export var gravity = Vector3.DOWN * 10
export var speed = 4
export var rot_speed = 0.85
onready var raycast = $Pivot/TankTop/RayCast
const Bullet = preload("res://Bullet.tscn")
var velocity = Vector3.ZERO

func _ready():
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
	if Input.is_action_just_pressed("inventory_toggle"):
		$InventoryContainer.visible = !$InventoryContainer.visible
	velocity.y = vy
	if Input.is_action_pressed("fire"):
		var coll = raycast.get_collider()
		if raycast.is_colliding() and coll.has_method("kill"):
			coll.kill()

func kill():
	get_tree().change_scene("res://DeadScreen.tscn")
