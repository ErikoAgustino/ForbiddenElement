extends Node2D

var type = "idle"

func _ready():
	$AnimationPlayer.play(type)
	$Timer.start(1)

func _on_Timer_timeout():
	queue_free()
	
func setPosition(pos):
	position = pos

func setType(tp):
	type = tp

func FlipSprite(bol):
	$Sprite2.flip_h = bol
