extends KinematicBody2D

var playerPath = "../Player"
var player
var me
var facingRight
var motion = Vector2()
const up = Vector2(0,-1)
var maxMoveSpeed = 100
var moveSpeed = 70
var gravity = 80
var maxFallSpeed = 500
var isGravity = false
var active
var elementReaction
var hp
var frozen
var destroyOnce = true


func _ready():
	hp = 10
	$HP.max_value = hp
	$HP.value = hp
	frozen = false
	facingRight = true
	active = true
	elementReaction = get_node("Reaction")
	player = get_node(playerPath)
	
func _physics_process(delta):
	if(active and not frozen and destroyOnce):
		me = get_position()
		$AnimationPlayer.play("run")
		#EnemyMovement()
		

	motion = move_and_slide(motion,up)
	$HP.value = hp
	
	if(destroyOnce):
		FallGravity()
			
	if(hp < 1 and destroyOnce):
		motion.y = lerp(motion.y,0,1)
		motion.x = lerp(motion.x,0,1)
		destroyOnce = false
		$CollisionShape2D.queue_free()
		$AreaCollide.queue_free()
		$Sprite.visible = false
		$Explotion.setExplode()
		GlobalPlayer.addHp(5)
	
"""
func CollideWithPlayer():
	for x in get_slide_count():
		var tempCollider = get_slide_collision(x).collider
		print(tempCollider.name)
"""	

func MeleeHitColide(dmg):
	hp -= dmg
		
func ElementHitColide(dmg, type):
	if(active):
		hp -= dmg
		if(type == "Fireball"):
			#GlobalPlayer.addHp(5)
			#queue_free()
			Reaction(elementReaction.ApplyElement("fire"))
		elif(type == "IceBullet"):
			Reaction(elementReaction.ApplyElement("ice"))
		elif(type == "WaterBall"):
			Reaction(elementReaction.ApplyElement("water"))

func Reaction(reaction):
	if(reaction == "frozen"):
		elementReaction.setFrozen()
		frozen = true
		motion.x = lerp(motion.x,0,1)
		$AnimationPlayer.stop()
		$Timer.start(3)
	elif(reaction == "vaporize"):
		hp -= 1
	elif(reaction == "melt"):
		$Timer.start(0.1)
		hp -= 2

func FallGravity():
	motion.y += gravity
	if(motion.y > maxFallSpeed):
		motion.y = maxFallSpeed

func EnemyMovement():
	if(facingRight):
		$Sprite.flip_h = false
	else:
		$Sprite.flip_h = true
	
	motion.x = clamp(motion.x,-maxMoveSpeed,maxMoveSpeed)
	if($RayCast2D.is_colliding()):
		if(player.getPosition().x - me.x > 200):
			motion.x += moveSpeed
			facingRight = false
		elif(player.getPosition().x - me.x < -200):
			motion.x -= moveSpeed			
			facingRight = true
		else:
			$AnimationPlayer.stop()
			$Sprite.frame = 12
			motion.x = lerp(motion.x,0,0.7)
	else:
		if(facingRight):
			motion.x += moveSpeed
		else:
			motion.x -= moveSpeed
		$AnimationPlayer.stop()
		$Sprite.frame = 12
		motion.x = lerp(motion.x,0,0.7)

func _on_Frozen_timeout():
	elementReaction.setUnFrozen()
	frozen = false

func _on_AreaCollide_body_entered(body):
	if(body.has_method("KnockBack")):
		if(body.getPosition().x - position.x < 0):
			body.KnockBack(-1)
		else:
			body.KnockBack(1)
		if(body.has_method("PlayerGetHit")):
			body.PlayerGetHit(2)

func Stop():
	active = false

func getPlayerPos():
	return player.getPosition()

func Destroy():
	queue_free()
