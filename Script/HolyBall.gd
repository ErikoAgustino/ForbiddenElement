extends KinematicBody2D

var motion = Vector2()
const up = Vector2(0,-1)
var fireSpeed
var destroyOnce
var dmg = 20
var skillRange = 1.7
var skillCurrentRange = 0

func _ready():
	destroyOnce = true
	if(GlobalPlayer.facingRight):
		fireSpeed = +1000
		$repeatable.flip_h = false
		$impact.flip_h = false
	else:
		fireSpeed = -1000
		$impact.flip_h = true
		$repeatable.flip_h = true
		
	$AnimationPlayer.play("idle")

func _physics_process(delta):
	motion.x = fireSpeed
	if(destroyOnce):
		motion = move_and_slide(motion, up)
			
	skillCurrentRange += delta
	if(skillCurrentRange > skillRange and destroyOnce):
		hitExplode()
		
	
func setPosition(pos):
	position = pos

func _on_Timer_timeout():
	queue_free()

func _on_AreaCollide_body_entered(body):
	if(destroyOnce and body.has_method("ElementHitColide")):
		body.ElementHitColide(dmg, "HolyBall")
	hitExplode()
	

func hitExplode():
	$AnimationPlayer.play("hit")
	$Timer.start(0.7)
	destroyOnce = false
