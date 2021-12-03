extends Sprite



func _ready():
	visible = false
	
func ZaWarudo():
	visible = true
	$AnimationPlayer.play("zaWarudo")
	$Timer.start(2)

func _on_Area2D_body_entered(body):
	if(body.has_method("Stop")):
		body.Stop()
		
func _on_Timer_timeout():
	visible = false
