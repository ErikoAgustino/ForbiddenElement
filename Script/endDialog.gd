extends Node2D

var active

func _ready():
	active = false
	
func _process(delta):
	if(active):
		if(!GlobalPlayer.get_is_DialogActive()):
			get_parent().get_node("portal").setIsActive(true)
			get_tree().change_scene("res://Scene/Win.tscn")
			
func ShowDialog():
	active = true
	get_parent().get_node("Canvas/DialogEnd").setActive()

