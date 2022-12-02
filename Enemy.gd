extends KinematicBody
 
const MOVE_SPEED = 3
 
var player = null
var dead = false
 
func _ready():	
	add_to_group("enemies")
 
func _physics_process(delta):
	if dead:
		return
	if player == null:
		return
 
	var vec_to_player = player.translation - translation
	vec_to_player = vec_to_player.normalized()
 
	move_and_collide(vec_to_player * MOVE_SPEED * delta)
 
func kill():
	dead = true
	$CollisionShape.disabled = true
 
func set_player(p):
	player = p
