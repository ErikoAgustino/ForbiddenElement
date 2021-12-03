extends KinematicBody2D

const up = Vector2(0,-1)
const gravity = 70
const maxFallSpeed = 800
const maxMoveSpeed = 300
const moveSpeed = 120
const jumpForce = -1050
const maxJump = 2
const cdBlink = 1
const smoke = preload("res://Prefabs/Util/smoke.tscn")

var checkPoint 
var timeBlinkCount = 0
var motion = Vector2()
var jumpCount = 0
var ground = 0
var shootCD = 2
var timerHp = 0
var knockX = 500
var knockY = -1000
var dead = false
var isMeleeAttacking = false
var attackComboCD = 0
var isElementAttacking = false
var isKnockingBack = false
var afterGethitCount = 0
var isInvisible = false
var jumpAttack = false

func _ready():
	position = GlobalPlayer.getPos()
	DefaultCollisionLayer()
	
func _physics_process(delta):
	timeBlinkCount += delta
	afterGethitCount += delta
	shootCD += delta

	if(is_on_floor()):
		jumpCount = 0
		ground = motion.y
	
	if(get_position().y > 1000):
		GlobalPlayer.setHp(GlobalPlayer.getHp() - 5)
		ReturnToCheckpoint()
	
	FallGravity()

	if(!GlobalPlayer.get_is_DialogActive()):
		if(!isKnockingBack):
			if(!isMeleeAttacking and !isElementAttacking):
				Movement()
				Jump()
			if(shootCD > 0.3):
				Attack()

		motion = move_and_slide(motion,up)
		if(Input.is_action_just_pressed("shoot")):
			if(GlobalPlayer.getHp() > 1 and shootCD > 0.3):
				shootCD = 0
				Shoot()
		
		timerHp += delta
		GenerateHp()
		
		ChangeSkills()
	
	else:
		$AnimatedSprite.play("idle")
		motion = move_and_slide(Vector2(0,maxFallSpeed), up)
		
	if(GlobalPlayer.getHp() < 1):
		get_tree().change_scene("res://Scene/Death.tscn")

func ChangeSkills():
	if(Input.is_action_just_pressed("skillUp")):
		GlobalPlayer.ChangeSkillUp()
	elif(Input.is_action_just_pressed("skillDown")):
		GlobalPlayer.ChangeSkillDown()
	
func Shoot():
	if(!isElementAttacking):
		print("ok")
		$AnimatedSprite.play("skill")
		GlobalPlayer.minHp(2)
		var pathSkill = GlobalPlayer.getActiveSkillPath()
		
		var loadSkill = load(pathSkill)
		var skill = loadSkill.instance()
		skill.setPosition(position)
		
		get_parent().add_child(skill)
		isElementAttacking = true
		$TimerSkill.start(1)
	
func FallGravity():
	if(!jumpAttack):
		motion.y += gravity
		if(motion.y > maxFallSpeed):
			motion.y = maxFallSpeed

func ReturnToCheckpoint():
	position = GlobalPlayer.getPos()
	
func Movement():
	if(GlobalPlayer.getFacing()):
		$AnimatedSprite.flip_h = false
		$swordHit/melee.position.x = 75
	else:
		$AnimatedSprite.flip_h = true
		$swordHit/melee.position.x = -100
	
	motion.x = clamp(motion.x,-maxMoveSpeed,maxMoveSpeed)
	
	if(Input.is_action_pressed("right")):
		if(Input.is_action_just_pressed("shift")):
			if(timeBlinkCount > 1):
				timeBlinkCount = 0
				poofSmoke(position)
				motion.x +=  8000
		else:
			motion.x += moveSpeed
			
		if(isInvisible):
			$AnimatedSprite.play("running")
		else:
			$AnimatedSprite.play("running")
		GlobalPlayer.setFacing(true)
		
	elif(Input.is_action_pressed("left")):
		if(Input.is_action_just_pressed("shift")):
			if(timeBlinkCount > 1):
				timeBlinkCount = 0
				poofSmoke(position)
				motion.x -= 8000
		else:
			motion.x -= moveSpeed
		
		if(isInvisible):
			$AnimatedSprite.play("running")
		else:
			$AnimatedSprite.play("running")
		GlobalPlayer.setFacing(false)
		
	else:
		motion.x = lerp(motion.x,0,0.5)
		$AnimatedSprite.play("idle")
	
	if(!is_on_floor()):
		if(motion.y > ground):
			pass
		else:
			$AnimatedSprite.play("jump")

func poofSmoke(pos):
	var smokeBlink = smoke.instance()
	smokeBlink.setPosition(pos)
	get_parent().add_child(smokeBlink)
	

func Jump():
	if(Input.is_action_just_pressed("jump") and jumpCount < maxJump):
		motion.y = jumpForce	
		jumpCount += 1
		
func Attack():
	if(Input.is_action_just_pressed("attack") and !isMeleeAttacking):
		isMeleeAttacking = true

		motion.x = lerp(motion.x,0,1)
		if(is_on_floor()):
			match attackComboCD:
				0:
					$AnimatedSprite.play("attack1")
					$TimerMelee.start(0.5)
					attackComboCD = 1
				1:
					$AnimatedSprite.play("attack2")
					$TimerMelee.start(0.5)
					attackComboCD = 2
				2:
					$AnimatedSprite.play("attack3")
					$TimerMelee.start(0.5)
					attackComboCD = 3
				3:
					$AnimatedSprite.play("spinAttack")
					$TimerMelee.start(0.8)
					attackComboCD = 0
		else:
			$AnimatedSprite.play("jumpAttack")
			jumpAttack = true
			motion.y = 0
			$TimerMelee.start(0.6)
			
func _on_TimerMelee_timeout():
	isMeleeAttacking = false
	jumpAttack = false
	
func GenerateHp():
	if(timerHp > 2 and shootCD > 2 and afterGethitCount > 2):
		timerHp = 0
		GlobalPlayer.addHp(1)

func KnockBack(lr):
	if(lr < 0):
		knockX = abs(knockX) * -1
	else:
		knockX = abs(knockX)
	motion.y = lerp(10,knockY,0.7)
	motion.x = lerp(motion.x, knockX, 0.7)
	#$AnimationPlayer.play("knock")
	isKnockingBack = true
	$swordHit/melee.disabled = true
	ResetCollisionLayer()
	set_collision_layer_bit(7,true)
	set_collision_mask_bit(0,true)

	$TimerKnock.start(0.7)

func DefaultCollisionLayer():
	set_collision_layer_bit(1,true)
	set_collision_mask_bit(0,true)
	set_collision_mask_bit(3,true)
	set_collision_mask_bit(4,true)
	set_collision_mask_bit(6,true)
	
func ResetCollisionLayer():
	for x in range(20):
		set_collision_layer_bit(x,false)
		set_collision_mask_bit(x,false)
	
func PlayerGetHit(dmg):
	afterGethitCount = 0
	GlobalPlayer.minHp(dmg)

func _on_swordHit_body_entered(body):
	if(body.has_method("setMotion")):
		body.setMotion(body.position - getPosition())
	else:
		if(body.has_method("MeleeHitColide")):
			body.MeleeHitColide(2)

func _on_TimerKnock_timeout():
	isKnockingBack = false
	isInvisible = true
	$TimerInvisible.start(1)

func getPosition():
	return position

func _on_TimerInvisible_timeout():
	isInvisible = false
	ResetCollisionLayer()
	DefaultCollisionLayer()


func _on_TimerSkill_timeout():
	isElementAttacking = false
