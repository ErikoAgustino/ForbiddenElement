extends KinematicBody2D



var motion = Vector2()
var speed = 500
var destroyOnce = true
var cd = 0
var bulletRange = 5
var bulletCurrentRange = 0
var turnCount = 0
var turn = 300
var player

func _ready():
	$Sprite/AnimationPlayer.play("idle")
	
func _physics_process(delta):
	var collision = move_and_collide(motion.normalized() * delta * speed)
	cd += delta
	
	bulletCurrentRange += delta
	if(bulletCurrentRange > bulletRange):
		queue_free()
	
	if(motion.x > 0):
		$Sprite.flip_h = false
		turn = -300
		if(player.getPosition().x - position.x < turn and turnCount < 1):
			turnCount += 1
			setMotion(player.getPosition() - position)
	else:
		$Sprite.flip_h = true
		if(player.getPosition().x - position.x > turn and turnCount < 1):
			turnCount += 1
			setMotion(player.getPosition() - position)


func _on_AreaCollide_body_entered(body):
	$CollisionShape2D.queue_free()
	if(body.has_method("PlayerGetHit")):
		body.PlayerGetHit(7)
	queue_free()

func setMotion(target):
	motion = target
	
func setPosition(pos):
	position = pos

func setPlayer(pl):
	player = pl
