extends KinematicBody2D

const playerPath = "../../Player"
const blobMinion = preload("res://Prefabs/Enemy/BlobMinion.tscn")
const spawnSmoke = preload("res://Prefabs/Util/smoke.tscn")

var active
var destroyOnce = true
var motion = Vector2()
const up = Vector2(0,-1)
var maxMoveSpeed = 200
var moveSpeed = 30
var player
var isFlying
var isIdling
onready var worldRightEnd = 2700
var move = 0
var hp
var readyFirstAttack = false
var readySecondAttack = false
var prepareSecondAttack = false
var readyThirdAttack = false
var spawned = false

func _ready():
	player = get_node(playerPath)
	active = false
	isFlying = false
	isIdling = false
	IdleAnimation()
	hp = 20
	$HP.max_value = hp
	$HP.value = hp
	$Smoke.visible = false

func _process(delta):
	if(active and destroyOnce):	

		match move:
			0:
				EnemyMovement()
				FlyUp()
			1:
				if(!readyFirstAttack):
					FirstMove()
				else:
					FirstAttack()
			2:
				if(!prepareSecondAttack):
					SecondMove()
				else:
					if(readySecondAttack):
						SecondAttack()
					else:
						SecondMoveDive()
			3:
				if(get_parent().get_child_count() < 2):
					if(!spawned):
						if(readyThirdAttack):
							ThirdAttack()
						else:
							ThirdMove()
					else:
						spawned = false
						hp -= 5
						move = 0
				else:
					readyThirdAttack = false
					spawned = true
				
	motion = move_and_slide(motion,up)
	$HP.value = hp
	
	if(hp < 1 and destroyOnce):
		Death()
		

func _on_AnimationTimer_timeout():
	$AnimationPlayer.play("fly")

func _on_AreaCollide_body_entered(body):
	if(body.has_method("KnockBack")):
		if(body.getPosition().x - position.x < 0):
			body.KnockBack(-1)
		else:
			body.KnockBack(1)
		if(body.has_method("PlayerGetHit")):
			body.PlayerGetHit(10)


func EnemyMovement():
	motion.x = clamp(motion.x,-maxMoveSpeed,maxMoveSpeed)
	
	if(player.getPosition().x - position.x > 130):
		motion.x += moveSpeed
		FlyAnimation()
		FlipSprite(true)
	elif(player.getPosition().x - position.x < -130):
		motion.x -= moveSpeed
		FlyAnimation()
		FlipSprite(false)
	else:
		motion.x = lerp(motion.x,0,0.7)

func FlipSprite(bol):
	$WizardAttack.flip_h = bol
	$WizardFly.flip_h = bol
	$WizardIdle.flip_h = bol

func FlyAnimation():
	if(!isFlying):
		$AnimationPlayer.play("startFly")
		isFlying = true
		isIdling = false
		$AnimationTimer.start(0.3)
	else:
		$AnimationPlayer.play("fly")
		
func IdleAnimation():
	if(!isIdling):
		$AnimationPlayer.play("startIdle")
		yield(get_tree().create_timer(1.1), "timeout")
		isIdling = true
		isFlying = false
		$AnimationPlayer.play("idle")
	else:
		$AnimationPlayer.play(IdleAnimation())

func FirstMove():
	if(position.y < -130):
		motion.y = lerp(200,100,0.2)
	else:
		motion.y = lerp(0,0,1)
	
	motion.x = clamp(motion.x,-1300,1300)
	if($WizardAttack.flip_h):
		if(position.x < worldRightEnd):
			motion.x += moveSpeed
			FlyAnimation()
		else:
			motion.x = lerp(0,0,1)
	else:
		if(position.x > -50):
			motion.x -= moveSpeed
			FlyAnimation()
		else:
			motion.x = lerp(0,0,1)
	
	if(motion == Vector2(0,0)):
		readyFirstAttack = true
		FlipSprite(!$WizardAttack.flip_h)

func FirstAttack():
	motion.x = clamp(motion.x,-1300,1300)
	
	if($WizardAttack.flip_h):
		if(position.x < worldRightEnd):
			motion.x += moveSpeed
			FlyAnimation()
		else:
			motion.x = lerp(0,0,1)
			readyFirstAttack = false
			move = 2
			yield(get_tree().create_timer(0.5), "timeout")
			FlipSprite(!$WizardAttack.flip_h)
	else:
		if(position.x > -50):
			motion.x -= moveSpeed
			FlyAnimation()
		else:
			motion.x = lerp(0,0,1)
			readyFirstAttack = false
			move = 2
			yield(get_tree().create_timer(0.5), "timeout")
			FlipSprite(!$WizardAttack.flip_h)
			

func SecondMove():
	motion.x = clamp(motion.x,-1300,1300)
	if($WizardAttack.flip_h):
		if(position.x < worldRightEnd):
			motion.x += moveSpeed
			FlyAnimation()
		else:
			motion.x = lerp(0,0,1)
			prepareSecondAttack = true
	else:
		if(position.x > -50):
			motion.x -= moveSpeed
			FlyAnimation()
		else:
			motion.x = lerp(0,0,1)
			prepareSecondAttack = true
	
func SecondMoveDive():
	if(position.y < 103):
		motion.y = lerp(800,200,0.2)
	else:
		motion.y = lerp(0,0,1)
	
	motion.x = clamp(motion.x,-300,300)
	if(player.getPosition().x - position.x > 30):
		motion.x += moveSpeed
	elif(player.getPosition().x - position.x < -30):
		motion.x -= moveSpeed
	else:
		motion.x = lerp(0,0,1)
		$Smoke.visible = true
		$AnimationPlayer.play("smoke")
		CountDownSecondAttack()

func CountDownSecondAttack():
	yield(get_tree().create_timer(1.0), "timeout")
	readySecondAttack = true
	
func SecondAttack():
	$Smoke.visible = false
	if(position.y > -450):
		motion.y = lerp(-800,-300,0.2)
	else:
		move = 3
		motion.y = lerp(0,0,1)
		readySecondAttack = false
		prepareSecondAttack = false

func ThirdMove():
	motion.x = clamp(motion.x,-300,300)
	if(1370 - position.x > 100):
		motion.x += moveSpeed
		FlyAnimation()
		FlipSprite(true)
	elif(1370 - position.x < -100):
		motion.x -= moveSpeed
		FlyAnimation()
		FlipSprite(false)
	else:
		motion.x = lerp(0,0,1)
		IdleAnimation()

		yield(get_tree().create_timer(1.0), "timeout")
		readyThirdAttack = true
	
func ThirdAttack():
	var minion = blobMinion.instance()
	var smoke = spawnSmoke.instance()
	var temp = position
	if($WizardAttack.flip_h):
		temp.x += 150
	else:
		temp.x -= 150
	
	smoke.setPosition(temp)
	minion.setDropItem(false)
	minion.position = temp
	
	get_parent().add_child(minion)
	get_parent().add_child(smoke)

func FlyUp():
	if(position.y > -450):
		motion.y = lerp(-200,-50,0.2)
	else:
		motion.y = lerp(0,0,1)
		move = 1

func Death():
	motion.y = lerp(motion.y,0,1)
	motion.x = lerp(motion.x,0,1)
	$WizardAttack.visible = false
	$WizardFly.visible = false
	$WizardIdle.visible = false
	destroyOnce = false
	$CollisionShape2D.queue_free()
	$AreaCollide.queue_free()
	GlobalMap.setIsSpawnBossOne(true)
	get_parent().get_node("../Utility/portal").setIsActive(true)
	get_parent().get_node("../Utility/portal2").setIsActive(true)
	$Explotion.setExplode()

func Destroy():
	var cape = load("res://Prefabs/InventoryItems/FlyingCape.tscn").instance()
	var cont = load("res://Prefabs/InventoryItems/PickcableContainer.tscn").instance()
		
	cont.add_child(cape)
	cont.setItem(cape)
	cont.setPosition(position)
	get_parent().add_child(cont)
	
	queue_free()

func setPosition(vector):
	position = vector
	
func setIsActive(bol):
	active = bol
