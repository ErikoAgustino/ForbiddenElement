extends Control


func _ready():
	SoundManager.stop("MainMusic")
	SoundManager.play_bgm("EndMusic")
	var dir = Directory.new()
	dir.remove("user://save.dat")

func _on_Exit_pressed():
	SoundManager.stop("EndMusic")
	get_tree().change_scene("res://Scene/Menu.tscn")
