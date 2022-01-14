extends Control


func _ready():
	visible = false

func _input(event):
	if(Input.is_action_just_pressed("esc")):
		visible = true
		get_parent().get_node("AndroidControl").visible = false
		get_tree().paused = true	
		

func _on_Exit_pressed():
	get_tree().paused = false
	SoundManager.stop("MainMusic")
	get_tree().change_scene("res://Scene/Menu.tscn")


func _on_Resume_pressed():
	visible = false
	get_parent().get_node("AndroidControl").visible = true
	get_tree().paused = false
