extends KinematicBody2D



var motion = Vector2()
var speed = 1000
var destroyOnce = true
var cd = 0
var bulletRange = 5
var bulletCurrentRange = 0

func _ready():
	pass
	
func _physics_process(delta):
	var collision = move_and_collide(motion.normalized() * delta * speed)
	cd += delta
	
	bulletCurrentRange += delta
	if(bulletCurrentRange > bulletRange):
		queue_free()
	
	if(get_parent().get_node("Player").getPosition().x - position.x > 500 ):
		setMotion(get_parent().get_node("Player").getPosition() - position)

func _on_AreaCollide_body_entered(body):
	$CollisionShape2D.queue_free()
	if(body.has_method("PlayerGetHit")):
		body.PlayerGetHit(3)
	elif(body.has_method("SelfDestroy")):
		body.SelfDestroy()
	queue_free()

func setMotion(target):
	motion = target
