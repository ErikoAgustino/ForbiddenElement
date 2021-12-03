extends Control

func _ready():
	$Transition.FadeOut()
	$back.grab_focus()

func _on_back_pressed():
	get_tree().change_scene("res://Scene/Menu.tscn")
