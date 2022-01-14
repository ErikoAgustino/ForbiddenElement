extends KinematicBody2D

var motion = Vector2()
const up = Vector2(0,-1)
var gravity = 150
var maxFallSpeed = 800
var active

func _ready():
	active = false
	$AnimationPlayer.play("SpawnRock")
			
func _physics_process(delta):
	if(active):		
		if(is_on_floor()):
			$AnimationPlayer.play("impact")
		else:
			FallGravity()
		
	motion = move_and_slide(motion,up)

func FallGravity():
	motion.y += gravity
	if(motion.y > maxFallSpeed):
		motion.y = maxFallSpeed

func setPosition(pos):
	position = pos

func _on_Area2D_body_entered(body):
	if(body.has_method("KnockBack")):
		if(body.getPosition().x - position.x < 0):
			body.KnockBack(-1)
		else:
			body.KnockBack(1)
		if(body.has_method("PlayerGetHit")):
			body.PlayerGetHit(15)


func _on_AnimationPlayer_animation_finished(anim_name):
	if(anim_name == "SpawnRock"):
		active = true
	else:
		queue_free()
