extends Node2D


func _ready():
	visible = false	

func setExplode():
	visible = true
	$AnimationPlayer.play("explode")
	$Timer.start(0.7)

func _on_Timer_timeout():
	if(get_parent().has_method("Destroy")):
		get_parent().Destroy()
