extends KinematicBody
 
const MOVE_SPEED = 8
var player = null
var dead = false
var startingPosition
onready var raycast = $RayCast
onready var inventory = ["res://res/icons/beetle_armor.png","res://res/icons/mantis_arm.png","res://res/icons/spider_legs.png"]

func _ready():	
	add_to_group("enemies")
	startingPosition = transform.origin
	
func _physics_process(delta):
	if dead:
		return
	if player == null:
		return
	var vec_to_player = player.translation - translation
	vec_to_player = vec_to_player.normalized()
	look_at(player.translation, Vector3.UP)
	move_and_collide(vec_to_player * MOVE_SPEED * delta)

func _process(delta):
	if !dead:
		attack()

func attack():
	var coll = raycast.get_collider()
	if raycast.is_colliding() and coll.has_method("kill") and coll == player:
		coll.kill()
 
func open_inventory():
	print("Here you go!")

func kill():
	rotate_x(deg2rad(int(180)))
	dead = true
	$CollisionShape.disabled = true	
 
func set_player(p):
	player = p


