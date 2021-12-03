extends KinematicBody2D

const up = Vector2(0,-1)
const gravity = 60
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
var isKnockingBack = false
var afterGethitCount = 0
var isInvisible = false

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

	if(Input.is_action_just_pressed("p")):
		$timestop.ZaWarudo()
		$TimerGhost.start(0.1)


	if(is_on_floor()):
		jumpCount = 0
		ground = motion.y
	
	if(get_position().y > 1000):
		GlobalPlayer.setHp(GlobalPlayer.getHp() - 5)
		ReturnToCheckpoint()
	
	FallGravity()

	if(!GlobalPlayer.get_is_DialogActive()):
		if(!isKnockingBack):
			if(!isMeleeAttacking):
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
		$AnimationPlayer.play("idle")
		motion = move_and_slide(Vector2(0,maxFallSpeed), up)
		
	if(GlobalPlayer.getHp() < 1 and !dead):
		dead = true
		$Explotion.setExplode()

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
	get_tree().change_scene("res://Scene/Death.tscn")
	queue_free()


func ChangeSkills():
	if(Input.is_action_just_pressed("skillUp")):
		GlobalPlayer.ChangeSkillUp()
	elif(Input.is_action_just_pressed("skillDown")):
		GlobalPlayer.ChangeSkillDown()
	
func Shoot():
	GlobalPlayer.minHp(2)
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
	
func Movement():
	if(GlobalPlayer.getFacing()):
		$Sprite.flip_h = false
		$swordHit/melee.position.x = 75
	else:
		$Sprite.flip_h = true
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
			$AnimationPlayer.play("runInvisible")
		else:
			$AnimationPlayer.play("run")
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
			$AnimationPlayer.play("runInvisible")
		else:
			$AnimationPlayer.play("run")
		GlobalPlayer.setFacing(false)
		
	else:
		motion.x = lerp(motion.x,0,0.5)
		$AnimationPlayer.play("idle")
	
	if(!is_on_floor()):
		if(motion.y > ground):
			$AnimationPlayer.play("fall")
		else:
			$AnimationPlayer.play("jump")

func poofSmoke(pos):
	var smokeBlink = smoke.instance()
	smokeBlink.setPosition(pos)
	get_parent().add_child(smokeBlink)
	

func Jump():
	if(Input.is_action_just_pressed("jump") and jumpCount < maxJump ):
		motion.y = jumpForce	
		jumpCount += 1
		
func Attack():
	if(Input.is_action_just_pressed("attack")):
		isMeleeAttacking = true
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
	set_collision_mask_bit(3,true)
	set_collision_mask_bit(4,true)
	set_collision_mask_bit(6,true)
	
func ResetCollisionLayer():
	for x in range(20):
		set_collision_layer_bit(x,false)
		set_collision_mask_bit(x,false)
	
func PlayerGetHit(dmg):
	afterGethitCount = 0
	
	if(GlobalPlayer.getEquipmentObject("body") != null):
		GlobalPlayer.sendRawDmg(dmg)
	else:
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


func _on_TimerGhost_timeout():
	var ghost = preload("res://Prefabs/Player/ghost.tscn").instance()
	get_parent().add_child(ghost)
	ghost.position = position
	ghost.frame = $Sprite.frame
	ghost.flip_h = $Sprite.flip_h
