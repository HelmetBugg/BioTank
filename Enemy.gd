extends KinematicBody
 
const MOVE_SPEED = 8
var player = null
var dead = false
var startingPosition
 
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
 
func kill():
	#dead = true
	#$CollisionShape.disabled = true
	#queue_free()
	transform.origin = startingPosition
 
func set_player(p):
	player = p
