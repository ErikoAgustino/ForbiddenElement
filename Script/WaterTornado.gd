extends KinematicBody2D

var active
var motion = Vector2()
var speed = 500
var startAt = 0

func _ready():
	$Sprite/AnimationPlayer.play("start")
	active = true
	$hit.visible = false
	
func _physics_process(delta):
	startAt += delta
	if(active and startAt > 0.3):
		$Sprite/AnimationPlayer.play("idle")
		var collision = move_and_collide(motion.normalized() * delta * speed)
		
func _on_Timer_timeout():
	queue_free()
	
func setPosition(pos):
	position = pos
	
func setMotion(target):
	motion = target

func _on_AreaCollide_body_entered(body):
	hitAnimation()
		
	if(body.has_method("PlayerGetHit")):
		body.PlayerGetHit(30)

	

func _on_AreaCollide_area_entered(area):
	hitAnimation()
		
func hitAnimation():
	motion.x = lerp(motion.x,0,1)
	
	$Sprite/AnimationPlayer.stop()
	$Sprite.visible = false
	
	$hit.visible = true
	$hit/AnimationPlayer.play("hit")
	
	$Timer.start(0.8)
	$CollisionShape2D.queue_free()
	$AreaCollide.queue_free()
