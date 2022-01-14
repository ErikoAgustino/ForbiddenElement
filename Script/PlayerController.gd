extends KinematicBody2D

const up = Vector2(0,-1)
const gravity = 60
const maxFallSpeed = 800
const maxMoveSpeed = 300
const moveSpeed = 120
const jumpForce = -1050
const cdBlink = 1
const smoke = preload("res://Prefabs/Util/smoke.tscn")

var checkPoint 
var timeBlinkCount = 0
var motion = Vector2()
var jumpCount = 0
var ground = 0
var shootCD = 2
var attackDelay = 0
var timerHp = 0
var knockX = 500
var knockY = -1000
var dead = false
var isMeleeAttacking = false
var isKnockingBack = false
var afterGethitCount = 0
var isInvisible = false
var isActive = true

func _ready():
	position = GlobalPlayer.getPos()
	DefaultCollisionLayer()
	LoadEquipments()
	GlobalPlayer.connect("addEquipment", self, "OnEquipItem")
	GlobalPlayer.connect("removeEquipment", self, "OnRemoveItem")
	
func _physics_process(delta):
	timeBlinkCount += delta
	afterGethitCount += delta
	shootCD += delta
	attackDelay += delta
	
	if(is_on_floor()):
		jumpCount = 0
		ground = motion.y
	
	FallGravity()

	if(!GlobalPlayer.get_is_DialogActive() and isActive and !dead):
		if(!isKnockingBack):
			if(!isMeleeAttacking):
				Movement()
				Jump()
			if(attackDelay > 0.4):
				Attack()

		motion = move_and_slide(motion,up)
			
		if(Input.is_action_just_pressed("shoot")):
			if(shootCD > 0.3):
				shootCD = 0
				Shoot()
	else:	
		$AnimationPlayer.play("idle")
		motion = move_and_slide(Vector2(0,maxFallSpeed), up)
		
	if(position.y > 1000):
		GlobalPlayer.setHp(0)
		
	if(GlobalPlayer.getHp() < 1 and !dead):
		dead = true
		$Sprite.visible = false
		$Jake.Death()
	
func LoadEquipments():		
	var allTypeEquipment = ["head", "sword", "sword2", "body"]
	for type in allTypeEquipment:
		if(GlobalPlayer.getEquipmentObject(type) != null):
			var equipment = GlobalPlayer.getEquipmentObject(type).getInstance()
			add_child(equipment)

func OnEquipItem(item):	
	var equipment = item.getInstance()
	add_child(equipment)

func OnRemoveItem(equipmentName):
	for child in get_children():
		if(child.name == equipmentName):
			child.queue_free()
			return
	return

func Destroy():
	SoundManager.stop("MainMusic")
	get_tree().change_scene("res://Scene/Death.tscn")

func ChangeSkills():
	if(Input.is_action_just_pressed("skillUp")):
		GlobalPlayer.ChangeSkillUp()
	elif(Input.is_action_just_pressed("skillDown")):
		GlobalPlayer.ChangeSkillDown()
	
func Shoot():
	SoundManager.play_se("shoot")
	GlobalPlayer.setSkillCD(10)
	var pathSkill = GlobalPlayer.getActiveSkillPath()
	
	var loadSkill = load(pathSkill)
	var skill = loadSkill.instance()
	skill.setPosition(position)
	
	get_parent().add_child(skill)
	
func FallGravity():
	motion.y += gravity
	if(motion.y > maxFallSpeed):
		motion.y = maxFallSpeed

func ReturnToCheckpoint():
	position = GlobalPlayer.getPos()

func setIsActive(bol):
	isActive = bol	

func Movement():
	if(GlobalPlayer.getFacing()):
		$Sprite.flip_h = false
		$swordHit/melee.position.x = 75
	else:
		$Sprite.flip_h = true
		$swordHit/melee.position.x = -100
	
	motion.x = clamp(motion.x,-maxMoveSpeed,maxMoveSpeed)
	
	if(Input.is_action_pressed("right")):
		if(Input.is_action_just_pressed("shift") and GlobalPlayer.getIsBlinkActive()):
			if(timeBlinkCount > 1):
				timeBlinkCount = 0
				poofSmoke(position)
				motion.x +=  8000
		else:
			motion.x += moveSpeed
			
		if(isInvisible):
			$AnimationPlayer.play("runInvisible")
		else:
			$AnimationPlayer.play("run")
		GlobalPlayer.setFacing(true)
		
	elif(Input.is_action_pressed("left")):
		if(Input.is_action_just_pressed("shift") and GlobalPlayer.getIsBlinkActive()):
			if(timeBlinkCount > 1):
				timeBlinkCount = 0
				poofSmoke(position)
				motion.x -= 8000
		else:
			motion.x -= moveSpeed
		
		if(isInvisible):
			$AnimationPlayer.play("runInvisible")
		else:
			$AnimationPlayer.play("run")
		GlobalPlayer.setFacing(false)
		
	else:
		motion.x = lerp(motion.x,0,0.5)
		if(isInvisible):
			$AnimationPlayer.play("idleInvisible")
		else:
			$AnimationPlayer.play("idle")
	
	if(!is_on_floor()):
		if(motion.y > ground):
			$AnimationPlayer.play("fall")
		else:
			$AnimationPlayer.play("jump")
			
func poofSmoke(pos):
	var smokeBlink = smoke.instance()
	if(is_on_floor()):
		smokeBlink.setType("idle1")
		smokeBlink.FlipSprite($Sprite.flip_h)
	else:
		smokeBlink.setType("idle")
	SoundManager.play_se("blink")
	smokeBlink.setPosition(pos)
	get_parent().add_child(smokeBlink)
	

func Jump():
	if(Input.is_action_just_pressed("jump") and jumpCount < GlobalPlayer.maxJump ):
		SoundManager.play_se("jump")
		motion.y = jumpForce	
		jumpCount += 1
		
func Attack():
	if(Input.is_action_just_pressed("attack")):
		isMeleeAttacking = true
		SoundManager.play_se("attack")
		attackDelay = 0
		$TimerMelee.start(0.4)
		motion.x = lerp(motion.x,0,1)
		$AnimationPlayer.play("attack")

func _on_TimerMelee_timeout():
	isMeleeAttacking = false
	
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
	$AnimationPlayer.play("knock")
	isKnockingBack = true
	$swordHit/melee.disabled = true
	ResetCollisionLayer()
	set_collision_layer_bit(7,true)
	set_collision_mask_bit(0,true)

	$TimerKnock.start(0.7)

func DefaultCollisionLayer():
	set_collision_layer_bit(1,true)
	set_collision_mask_bit(0,true)
	set_collision_mask_bit(4,true)
	set_collision_mask_bit(6,true)
	
func ResetCollisionLayer():
	for x in range(20):
		set_collision_layer_bit(x,false)
		set_collision_mask_bit(x,false)
	
func PlayerGetHit(dmg):
	if(!GlobalPlayer.get_is_DialogActive()):
		afterGethitCount = 0
		SoundManager.play_se("hurt")
		if(GlobalPlayer.getEquipmentObject("body") != null):
			GlobalPlayer.sendRawDmg(dmg)
		else:
			GlobalPlayer.minHp(dmg)
	
func _on_swordHit_body_entered(body):
	if(body.has_method("setMotion")):
		body.setMotion(body.position - getPosition())
	else:
		if(body.has_method("MeleeHitColide")):
			body.MeleeHitColide(5)
			if(body.has_method("KnockBack")):
				if(body.position.x - position.x > 0):
					body.KnockBack(1)
				else:
					body.KnockBack(-1)
				
	var particle = preload("res://Prefabs/Player/Skills/SwordParticle.tscn").instance()
	particle.setPosition(body.position)
	get_parent().add_child(particle)

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

func getFacing():
	return $Sprite.flip_h
