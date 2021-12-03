extends KinematicBody2D

const waterTornadoPath = preload("res://Prefabs/Enemy/Bullet/WaterTornado.tscn")
const windBoomerangPath = preload("res://Prefabs/Enemy/Bullet/Wind.tscn")

var playerPath = "../Player"
var player
var me
var facingRight
var motion = Vector2()
const up = Vector2(0,-1)
var maxMoveSpeed = 60
var moveSpeed = 50
var gravity = 80
var maxFallSpeed = 500
var isGravity = false
var active
var elementReaction
var hp
var frozen
var test = true
var destroyOnce = true
var timerAttack = 0
var secondAttackCount = 0
var move = 0


func _ready():
	hp = 20
	$HP.max_value = hp
	$HP.value = hp
	frozen = false
	active = false
	facingRight = true
	elementReaction = get_node("Reaction")
	player = get_node(playerPath)
	
func _physics_process(delta):
	if(active and destroyOnce):
		if(!frozen):
			me = get_position()
			$AnimationPlayer.play("idle")
			if(facingRight):
				$Sprite.flip_h = true
			else:
				$Sprite.flip_h = false
			#EnemyMovement()
			
			
			match move:
				0:
					FirstMove()
					timerAttack += delta
					if(timerAttack > 3):
						FirstMoveAttack()
						timerAttack = 0
				1:
					if(!is_on_floor()):
						SecondMove()
					else:
						EnemyMovement()

					if(is_on_floor()):
						timerAttack += delta
						if(timerAttack > 0.8):
							secondAttackCount += 1
							SecondMoveAttack()
							timerAttack = 0	
							
		if(isGravity):
			FallGravity()
	
		
	motion = move_and_slide(motion,up)
	$HP.value = hp
	
	if(hp < 1 and destroyOnce):
		#motion.y = lerp(motion.y,0,1)
		motion.y = lerp(-300,-100,0.2)
		motion.x = lerp(motion.x,0,1)
		print("show")
		get_parent().get_node("endDialog").ShowDialog()
		#$AreaCollide.queue_free()
		#$CollisionShape2D.queue_free()
		destroyOnce = false
		#$Sprite.visible = false
		#$Explotion.setExplode()
		GlobalPlayer.addHp(5)
	
"""
func CollideWithPlayer():
	for x in get_slide_count():
		var tempCollider = get_slide_collision(x).collider
		print(tempCollider.name)
"""	

func MeleeHitColide(dmg):
	if(active):
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
	motion.x = clamp(motion.x,-maxMoveSpeed,maxMoveSpeed)
	
	if(player.getPosition().x - me.x > 200):
		motion.x += moveSpeed
		facingRight = false
	elif(player.getPosition().x - me.x < -200):
		motion.x -= moveSpeed			
		facingRight = true
	else:
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


func ShootProjectile():
	var tornado = waterTornadoPath.instance()
				
	get_parent().add_child(tornado)
	var pos = position
	pos.y = 0
	pos.x -= 50
	tornado.setPosition(pos)

	var target = player.getPosition()
	target.y = 0
	tornado.setMotion(target - tornado.position)

func Destroy():
	get_parent().get_node("endDialog").ShowDialog()
	queue_free()


func _on_VisibilityNotifier2D_screen_entered():
	active = false
	
func Stop():
	active = false

func setIsActive(bol):
	active = bol

func FirstMove():
	isGravity = true
	motion.x = clamp(motion.x,-maxMoveSpeed,maxMoveSpeed)
	
	if(position.y > -500):
		motion.y = lerp(-300,-100,0.2)
	else:
		motion.y = lerp(0,0,1)
	
	if(player.getPosition().x - me.x > 80):
		motion.x += moveSpeed + 200
		facingRight = false
	elif(player.getPosition().x - me.x < -80):
		motion.x -= moveSpeed + 200	
		facingRight = true
	else:
		motion.x = lerp(motion.x,0,0.7)

func FirstMoveAttack():
	var tornadoL = waterTornadoPath.instance()
	var tornadoR = waterTornadoPath.instance()

	get_parent().add_child(tornadoL)
	get_parent().add_child(tornadoR)
	
	var target = player.getPosition()
	
	var posL = target
	posL.y = 0
	posL.x -= 400 
	tornadoL.setPosition(posL)

	var posR = target
	posR.y = 0
	posR.x += 400 
	tornadoR.setPosition(posR)

	target.y = 0
	tornadoL.setMotion(target - tornadoL.position)
	tornadoR.setMotion(target - tornadoR.position)
	
	move = 1

func SecondMove():
	isGravity = true
	
	motion.x = clamp(motion.x,-maxMoveSpeed,maxMoveSpeed)
	
	if(player.getPosition().x - me.x > 0):
		motion.x -= moveSpeed + 100
		facingRight = false
	elif(player.getPosition().x - me.x < 0):
		motion.x += moveSpeed + 100
		facingRight = true
	else:
		motion.x = lerp(motion.x,0,0.7)

func SecondMoveAttack():
	if(secondAttackCount < 4):
		var windBoomerang = windBoomerangPath.instance()
					
		get_parent().add_child(windBoomerang)
		
		var windPos = position
		windBoomerang.setPosition(windPos)
		
		windBoomerang.setMotion(player.getPosition() - windBoomerang.position)
	else:
		move = 0
		secondAttackCount = 0
