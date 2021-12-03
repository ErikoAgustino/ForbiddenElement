extends Node2D

func _ready():
	$Sprite/AnimationPlayer.play("idle")
	$Timer.start(1)

func _on_Timer_timeout():
	queue_free()
	
func setPosition(pos):
	position = pos
