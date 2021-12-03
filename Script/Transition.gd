extends Control


func _ready():
	visible = false
	
func FadeIn():
	visible = true
	$AnimationPlayer.play("transitionIn")
	$Timer.start(0.2)

func FadeOut():
	visible = true
	$AnimationPlayer.play("transitionOut")
	$Timer.start(0.3)

func hide():
	visible = false

func _on_Timer_timeout():
	hide()
