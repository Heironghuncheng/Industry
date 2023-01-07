extends Area2D

var placed : bool = false

var circled : bool = false

var owned : Node2D

# called once when the node is initialized
func _ready ():
	# add the tile to the "Tiles" group when the node is initialized
	add_to_group("Tiles")

func _on_Button_mouse_entered():
	add_to_group("Hover")

func _on_Button_mouse_exited():
	remove_from_group("Hover")
	
func turn_highlight(toggle:bool,color:String="blue"):
	if color == "blue":
		$Highlight.color = Color(0.192,0.423,0.972,1)
	if color == "red":
		$Highlight.color = Color(0.972,0.074,0.305,1)
	$Highlight.visible = toggle

func _on_Button_button_up():
	remove_from_group("Pressed")

func _on_Button_button_down():
	add_to_group("Pressed")
