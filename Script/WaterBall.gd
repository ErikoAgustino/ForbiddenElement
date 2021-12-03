extends KinematicBody2D



var motion = Vector2()
const up = Vector2(0,-1)
var waterSpeed
var destroyOnce
var dmg = 1
var skillRange = 1.7
var skillCurrentRange = 0

func _ready():
	destroyOnce = true
	if(GlobalPlayer.facingRight):
		waterSpeed = +1000
		$Sprite.flip_h = false
		$Hit.flip_h = false
	else:
		waterSpeed = -1000
		$Hit.flip_h = true
		$Sprite.flip_h = true
	
	$Hit.visible = false
	$Sprite/AnimationPlayer.play("idle")
		

func _physics_process(delta):
	motion.x = waterSpeed
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
		body.ElementHitColide(dmg, "WaterBall")
		hitExplode()
		
func hitExplode():
	$Hit.visible = true
	$Hit/AnimationPlayer.play("hit")
	$CollisionShape2D.queue_free()
	$Timer.start()
	destroyOnce = false
