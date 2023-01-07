extends Control

signal Begin

func _ready():
	yield(get_tree().create_timer(8),"timeout")
	$AnimationPlayer.play("FadeIn")
	$Beginer.queue_free()

func _on_Button_pressed():
	emit_signal("Begin")
