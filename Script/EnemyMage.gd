extends KinematicBody2D

const waterTornadoPath = preload("res://Prefabs/Enemy/Bullet/WaterTornado.tscn")
const windBoomerangPath = preload("res://Prefabs/Enemy/Bullet/Wind.tscn")
const thunderbirdPath = preload("res://Prefabs/Enemy/Bullet/ThunderBird.tscn")
const rockPath = preload("res://Prefabs/Enemy/Bullet/Order.tscn")
const waterPath = preload("res://Prefabs/Enemy/Bullet/WaterSpike.tscn")
const smokePath = preload("res://Prefabs/Util/smoke.tscn")

onready var playerPath = "../../Player"
onready var leftLimit = 100
onready var rightLimit = 2610
var player
var me
var facingRight
var motion = Vector2()
const up = Vector2(0,-1)
var maxMoveSpeed = 60
var moveSpeed = 50
var gravity = 80
var maxFallSpeed = 100
var isGravity = false
var active
var elementReaction
var hp
var test = true
var destroyOnce = true
var timerAttack = 0
var secondAttackCount = 0
var move = 0
var firstPhase = true
var teleportCD = 0
var randomCD = 0

func _ready():
	hp = 150
	$HP.max_value = hp
	$HP.value = hp
	active = false
	facingRight = true
	player = get_node(playerPath)
	$AnimationPlayer.play("idle")
	
func _physics_process(delta):

	if(active and destroyOnce):
		if(facingRight):
			$Mage.flip_h = true
			$RickAttack.flip_h = true
			$RickChange.flip_h = true
		else:
			$Mage.flip_h = false
			$RickAttack.flip_h = false
			$RickChange.flip_h = false
		#EnemyMovement()

		if(firstPhase):
			match move:
				0:
					EnemyMovement()
					randomCD += delta
					if(randomCD > 1):
						randomCD = 0
						var rand = round(rand_range(1,2))
						move = int(rand)
				1:
					FirstMove()
					timerAttack += delta
					if(timerAttack > 3):
						FirstMoveAttack()
						timerAttack = 0
				2:
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
				3:
					if(is_on_floor()):
						get_parent().get_node("../Canvas/DialogMid").setActive()
						hp = 150
						$AnimationPlayer.play("change")
						firstPhase = false
						timerAttack = 0
						move = 4
		else:
			FlipSprite()

			teleportCD += delta
			if(teleportCD > 4):
				Teleport()
				teleportCD = 0
	
			if(move == 0):
				randomCD += delta
				if(randomCD > 1.5):
					randomCD = 0
					var rand = round(rand_range(1,3))
					move = int(rand)
					timerAttack = 0
			elif(move == 1):
				if(timerAttack == 0):
					SecondPhaseFirstAttack()
				timerAttack += delta
			elif(move == 2):
				if(timerAttack == 0):
					SecondPhaseSecondAttack()
				timerAttack += delta
			elif(move == 3):
				if(timerAttack == 0):
					SecondPhaseThirdAttack()
				timerAttack += delta
			elif(move == 4):
				teleportCD = 0
				if(!GlobalPlayer.get_is_DialogActive()):
					move = 0
					
		if(isGravity):
			FallGravity()
			
	motion = move_and_slide(motion,up)
	$HP.value = hp
	
	if(hp < 1 and destroyOnce):
		if(firstPhase):
			move = 3
			motion.x = lerp(motion.x,0,1)
			isGravity = true
		else:
			motion.y = lerp(motion.y,0,1)
			motion.x = lerp(motion.x,0,1)
			get_parent().get_node("../Canvas/DialogEnd").setActive()
			$Explotion.setExplode()
			destroyOnce = false
	
func FlipSprite():
	if(player.getPosition().x - position.x > 10):
		facingRight = true
	elif(player.getPosition().x - position.x < -10):
		facingRight = false


func Teleport():

	var rand
	if(position.x == leftLimit):
		rand = 1
	elif(position.x == rightLimit):
		rand = 0
	else:
		rand = int(round(rand_range(0,1)))
	
	
	SmokeTeleport(position)
	if(rand == 0):
		if(position.x - 500 < leftLimit):
			position.x = leftLimit
		else:
			position.x -= 500
		SmokeTeleport(position)
	else:
		if(position.x + 500 > rightLimit):
			position.x = rightLimit
		else:
			position.x += 500
		SmokeTeleport(position)

func SmokeTeleport(pos):
	var smoke = smokePath.instance()
	smoke.setPosition(pos)
	get_parent().add_child(smoke)

			
func MeleeHitColide(dmg):
	if(active):
		hp -= dmg
		ShowDamage(dmg)
			
func ElementHitColide(dmg, type):
	if(active):
		hp -= dmg
		ShowDamage(dmg)

func ShowDamage(dmg):
	var labelDmg = preload("res://Prefabs/UI/DamageNumber.tscn").instance()
	add_child(labelDmg)
	labelDmg.ShowDamage(dmg)
	

func FallGravity():
	motion.y += gravity
	if(motion.y > maxFallSpeed):
		motion.y = maxFallSpeed

func EnemyMovement():
	motion.x = clamp(motion.x,-maxMoveSpeed,maxMoveSpeed)
	if(player.getPosition().x - position.x > 200):
		motion.x += moveSpeed
		facingRight = false
	elif(player.getPosition().x - position.x < -200):
		motion.x -= moveSpeed			
		facingRight = true
	else:
		motion.x = lerp(motion.x,0,0.7)

func _on_AreaCollide_body_entered(body):
	if(body.has_method("KnockBack")):
		if(body.getPosition().x - position.x < 0):
			body.KnockBack(-1)
		else:
			body.KnockBack(1)
		if(body.has_method("PlayerGetHit")):
			body.PlayerGetHit(10)


func ShootProjectile():
	var thunderBird = thunderbirdPath.instance()
				
	get_parent().add_child(thunderBird)
	var pos = position
	if(facingRight):
		pos.x += 60
	else:
		pos.x -= 60

	thunderBird.setPosition(pos)

	var target = player.getPosition()

	thunderBird.setMotion(target - thunderBird.position)

func SummonRock():
	var rock = rockPath.instance()
	
	get_parent().add_child(rock)
	
	var pos = player.getPosition()
	pos.y -= 400
	
	rock.setPosition(pos)

func SummonWater():
	var water = waterPath.instance()
	
	get_parent().add_child(water)
	
	var pos = player.getPosition()
	pos.y = -60
	
	water.setPosition(pos)

func Destroy():
	queue_free()

func _on_VisibilityNotifier2D_screen_entered():
	active = false
	
func Stop():
	active = false

func setIsActive(bol):
	active = bol

func FirstMove():
	isGravity = false
	motion.x = clamp(motion.x,-maxMoveSpeed,maxMoveSpeed)
	
	if(position.y >= -500):
		motion.y = lerp(-100,-80,0.2)
	else:
		motion.y = lerp(motion.y,0,1)
	
	if(player.getPosition().x - position.x > 80):
		motion.x += moveSpeed
		facingRight = false
	elif(player.getPosition().x - position.x < -80):
		motion.x -= moveSpeed
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
	posL.y = -65
	posL.x -= 400 
	tornadoL.setPosition(posL)

	var posR = target
	posR.y = -65
	posR.x += 400
	tornadoR.setPosition(posR)

	tornadoL.setMotion(Vector2(1,0))
	tornadoR.setMotion(Vector2(-1,0))
	
	move = 0

func SecondMove():
	isGravity = true
	
	motion.x = clamp(motion.x,-maxMoveSpeed,maxMoveSpeed)
	
	if(player.getPosition().x - position.x > 0):
		motion.x -= moveSpeed
		facingRight = false
	elif(player.getPosition().x - position.x < 0):
		motion.x += moveSpeed
		facingRight = true
	else:
		motion.x = lerp(motion.x,0,0.7)

func SecondMoveAttack():
	if(secondAttackCount < 4):
		var windBoomerang = windBoomerangPath.instance()		
		get_parent().add_child(windBoomerang)
		
		windBoomerang.setPlayer(player)
		var windPos = position
		windBoomerang.setPosition(windPos)
		
		windBoomerang.setMotion(player.getPosition() - windBoomerang.position)
	else:
		move = 0
		secondAttackCount = 0

func SecondPhaseFirstAttack():
	$AnimationPlayer.play("RickShootProjectile")

func SecondPhaseSecondAttack():
	$AnimationPlayer.play("RickAttackMagicRock")

func SecondPhaseThirdAttack():
	$AnimationPlayer.play("RickAttackMagicWater")

func setPosition(pos):
	position = pos

func _on_AnimationPlayer_animation_finished(anim_name):
	$AnimationPlayer.play("RickIdle")
	if(anim_name == "RickShootProjectile" or anim_name == "RickAttackMagicRock" or anim_name == "RickAttackMagicWater"):
		move = 0		

func _on_TimerAttack_timeout():
	move = 0
	$AnimationPlayer.play("RickIdle")


