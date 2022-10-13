extends Node

var mouse_sens = 0.3
var camera_anglev=0

func _input(event):         
	if event is InputEventMouseMotion:
		$Player/Pivot/TankTop.rotate_y(deg2rad(-event.relative.x*mouse_sens))
		$Player/Cam3D.rotate_y(deg2rad(-event.relative.x*mouse_sens))
		var changev=-event.relative.y*mouse_sens

func _init():
	Input.set_mouse_mode(2);
