extends Control


func _ready():
	visible = true	
	$HBoxContainer/Revive.grab_focus()


func _on_Revive_pressed():
	GlobalPlayer.resetHealth()
	get_tree().change_scene("res://Scene/level0.tscn")
	
func _on_Exit_pressed():
	get_tree().change_scene("res://Scene/Menu.tscn")
	
