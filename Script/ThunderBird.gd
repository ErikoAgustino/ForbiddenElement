extends KinematicBody2D

var motion = Vector2()
var speed = 1000
var bulletRange = 5
var bulletCurrentRange = 0
var release = false
func _ready():
	$AnimationPlayer.play("start")


func _physics_process(delta):
	if(release):
		move_and_collide(motion.normalized() * delta * speed)
		bulletCurrentRange += delta

		if(bulletCurrentRange > bulletRange):
			queue_free()

func setPosition(pos):
	position = pos
	
func setMotion(target):
	if(target.normalized().x < 0):
		$Thunder.flip_h = true
		$ThunderHit.flip_h = true
	else:
		$Thunder.flip_h = false
		$ThunderHit.flip_h = false
	motion = target

func _on_AnimationPlayer_animation_finished(anim_name):
	if(anim_name == "start"):
		release = true
		$AnimationPlayer.play("idle")
	else:
		queue_free()

func _on_Area2D_body_entered(body):
	if(body.has_method("PlayerGetHit")):
		body.PlayerGetHit(25)
	release = false
	$AnimationPlayer.play("hit")
