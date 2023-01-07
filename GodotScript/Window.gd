extends Camera2D
var begin = false
var pull = false
var mousePos
var currentPos
func _physics_process(delta):
	if begin:
		if Input.is_action_just_released("ScrollUp"):
			if zoom.x >= 0.3 and zoom.y >= 0.3:
				zoom.x -= 0.1
				zoom.y -= 0.1
#				$GUI.scale.x = zoom.x
#				$GUI.scale.y = zoom.y
		if Input.is_action_just_released("ScrollDown"):
			if zoom.x <= 0.9 and zoom.y <= 0.9:
				zoom.x += 0.05
				zoom.y += 0.05
#				$GUI.scale.x = zoom.x
#				$GUI.scale.y = zoom.y
		if Input.is_action_just_pressed("RMB"):
			mousePos = get_global_mouse_position()
		if Input.is_action_pressed("RMB"):
			currentPos = get_global_mouse_position()
			position.x -= currentPos.x-mousePos.x
			if position.x < -50:
				position.x = -50
			if position.x > 1970:
				position.x = 1970
			position.y -= currentPos.y - mousePos.y
			if position.y < 50:
				position.y = 50
			if position.y > 1106:
				position.y = 1106
#			$GUI.position.x = position.x
#			$GUI.position.y = position.y


func start_menu():
	zoom.x = 0.5
	zoom.y = 0.5
	position.x = 480
	position.y = 1864
	begin = false
	
func game_start():
	zoom.x = 0.5
	zoom.y = 0.5
	position.x = 960
	position.y = 528
	limit_bottom = 1106
	$UI.show()
	begin = true
