extends KinematicBody2D

export (int) var maxFly

var me
var motion = Vector2()
const up = Vector2(0,-1)
var gravity = 80
var maxFallSpeed = 500
var maxFlySpeed = -100
var active
var destroyOnce = true
var isAttacking

func _ready():
	isAttacking = false
			
func _physics_process(delta):
	if(active and destroyOnce):
		
		if(position.y > maxFly and !isAttacking):
			AntiGravity()
		else:
			if(is_on_floor()):
				isAttacking = false
			else:
				isAttacking = true
				FallGravity()
			
			
	motion = move_and_slide(motion,up)

func AntiGravity():
	motion.y -= 20
	if(motion.y < maxFlySpeed):
		motion.y = maxFlySpeed

func FallGravity():
	motion.y += gravity
	if(motion.y > maxFallSpeed):
		motion.y = maxFallSpeed

func _on_VisibilityNotifier2D_screen_entered():
	active = true

func Stop():
	active = false

func _on_Area2D_body_entered(body):
	if(body.has_method("KnockBack")):
		if(body.getPosition().x - position.x < 0):
			body.KnockBack(-1)
		else:
			body.KnockBack(1)
		if(body.has_method("PlayerGetHit")):
			body.PlayerGetHit(10)
