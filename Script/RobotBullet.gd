extends KinematicBody2D



var motion = Vector2()
var speed = 1000
var destroyOnce = true
var bulletRange = 5
var bulletCurrentRange = 0

func _ready():
	$Sprite/AnimationPlayer.play("idle")
	
func _physics_process(delta):
	var collision = move_and_collide(motion.normalized() * delta * speed)
	bulletCurrentRange += delta

	if(bulletCurrentRange > bulletRange):
		queue_free()

func _on_AreaCollide_body_entered(body):
	$CollisionShape2D.queue_free()
	if(body.has_method("PlayerGetHit")):
		body.PlayerGetHit(3)
	queue_free()

func setPosition(pos):
	position = pos
	
func setMotion(target):
	motion = target

