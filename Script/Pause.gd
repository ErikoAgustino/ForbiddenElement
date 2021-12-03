extends Control


func _ready():
	visible = false

func _input(event):
	if(Input.is_action_just_pressed("esc")):
		if(!visible):
			visible = true
			get_tree().paused = true	
		else:
			visible = false
			get_tree().paused = false
