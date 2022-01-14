extends Node2D


var once = true
var once2 = true
func _ready():
	pass

func _process(delta):
	if(get_parent().get_node("Canvas/DialogEnd") == null and once):
		once = false
		get_parent().get_node("Canvas/TextTransition").TextTransitionActive()
	if(get_parent().get_node("Canvas/DialogFinal") == null and once2):
		once2 = false
		get_tree().change_scene("res://Scene/EndScene.tscn")
	
