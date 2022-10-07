extends KinematicBody

export var gravity = Vector3.DOWN * 10
export var speed = 4
export var rot_speed = 0.85
const Bullet = preload("res://Bullet.tscn")
#export (PackedScene) var Bullet


var velocity = Vector3.ZERO

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
	velocity.y = vy
	if Input.is_action_just_pressed("fire"):
		var b = Bullet.instance()
		owner.add_child(b)
		b.transform = $Muzzle.global_transform
		b.velocity = -b.transform.basis.z * b.muzzle_velocity
