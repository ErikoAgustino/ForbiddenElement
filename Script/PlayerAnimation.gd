extends Node2D


func _ready():
	visible = false	

func Death():
	visible = true
	$AnimationPlayer.play("death1")
	$Timer.start(1.1)

func _on_Timer_timeout():
	if(get_parent().has_method("Destroy")):
		get_parent().Destroy()
