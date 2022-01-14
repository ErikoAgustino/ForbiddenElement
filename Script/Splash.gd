extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$label.percent_visible = 0
	$Tween.interpolate_property($label, "percent_visible", 0, 1, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func _on_Tween_tween_completed(object, key):
	yield(get_tree().create_timer(1.0), "timeout")
	get_tree().change_scene("res://Scene/Menu.tscn")
