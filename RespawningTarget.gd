extends KinematicBody

var velocity = Vector3.ZERO
export var gravity = Vector3.DOWN * 10

func _physics_process(delta):
	velocity += gravity * delta
	velocity = move_and_slide(velocity, Vector3.UP)
