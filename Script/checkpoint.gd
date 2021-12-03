extends Area2D

var player
var timerLabel = 0

func _ready():
	$Label.visible = false
	$sprite/AnimationPlayer.play("idle")


func _on_Timer_timeout():
	$Label.visible = false


func _on_CheckPoint_body_entered(body):
	if(body.name == "Player"):
		GlobalPlayer.setPos(position)
		$Label.visible = true
		$Timer.start(2)
