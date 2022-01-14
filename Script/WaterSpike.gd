extends Node2D


func _ready():
	var rand = int(round(rand_range(0,1)))
	if(rand == 0):
		$AnimationPlayer.play("WaterStart1")
	else:
		$AnimationPlayer.play("WaterStart2")

func _on_Area2D_body_entered(body):
	if(body.has_method("KnockBack")):
		if(body.getPosition().x - position.x < 0):
			body.KnockBack(-1)
		else:
			body.KnockBack(1)
		if(body.has_method("PlayerGetHit")):
			body.PlayerGetHit(30)

func setPosition(pos):
	position = pos

func _on_AnimationPlayer_animation_finished(anim_name):
	if(anim_name == "WaterStart1"):
		$AnimationPlayer.play("WaterSpike01")
	elif(anim_name == "WaterStart2"):
		$AnimationPlayer.play("WaterSplash02")
	else:
		queue_free()
