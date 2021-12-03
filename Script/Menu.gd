extends Control


func _ready():
	$Transition.FadeOut()
	$VBoxContainer/Start.grab_focus()


func _on_Start_pressed():
	get_tree().change_scene("res://Scene/level0.tscn")


func _on_Quit_pressed():
	get_tree().quit()


func _on_Credits_pressed():
	get_tree().change_scene("res://Scene/Credits.tscn")
