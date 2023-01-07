extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"



#var velocity : Vector2 = Vector2.ZERO
var speed : int = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func move(Up:bool,Down:bool,Left:bool,Right:bool,delta):
	var velocity : Vector2 = Vector2.ZERO
	if Up:
		velocity.y -= 1
	if Down: 
		velocity.y += 1
	if Left:
		velocity.x -= 1
	if Right:
		velocity.x += 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		
	position += velocity * delta
	position.x = clamp(position.x, 0, 1920)
	position.y = clamp(position.y, 0, 1056)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
