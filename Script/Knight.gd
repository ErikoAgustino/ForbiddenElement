extends KinematicBody2D


onready var playerPath = "../../Player"
var player
var facingRight
var motion = Vector2()
const up = Vector2(0,-1)
var maxMoveSpeed = 150
var moveSpeed = 80
var gravity = 80
var maxFallSpeed = 500
var isGravity = false
var active
var hp
var destroyOnce = true
var isAttacking = false
var readyAttack = false
var cdAtk = 0
var isKnockingBack = false
var knockX = 500

func _ready():
	hp = 60
	$HP.max_value = hp
	$HP.value = hp
	facingRight = true
	player = get_node(playerPath)
			
func _physics_process(delta):
	if(active and destroyOnce and !isKnockingBack):
		if(!isAttacking):
			EnemyMovement()
			
		if(readyAttack):
			cdAtk += delta
			if(cdAtk > 0.4):
				readyAttack = false
				Attack()
				cdAtk = 0
				
	motion = move_and_slide(motion,up)
	$HP.value = hp
	
	if(destroyOnce):
		FallGravity()
			
	if(hp < 1 and destroyOnce):
		Death()
		$Explotion.setExplode()
	

func MeleeHitColide(dmg):
	hp -= dmg
	ShowDamage(dmg)
		
func ElementHitColide(dmg, type):
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

func FlipSprite(bol):
	$Knight3Block.flip_h = bol
	$Knight3Idle.flip_h = bol
	$Knight3ImprovedSlashAnimation.flip_h = bol
	$KnightWalkAnimation.flip_h = bol
	if(bol):
		$Knight3ImprovedSlashAnimation.offset.x = -20
		$AreaAttack/CollisionShape2D.position.x = -86
	else:
		$Knight3ImprovedSlashAnimation.offset.x = 20
		$AreaAttack/CollisionShape2D.position.x = 86	
	
func EnemyMovement():
	if(facingRight):
		FlipSprite(true)
	else:
		FlipSprite(false)
		
	motion.x = clamp(motion.x,-maxMoveSpeed,maxMoveSpeed)
	
	if(player.getPosition().x - position.x > 100):
		$AnimationPlayer.play("walk")
		motion.x += moveSpeed
		facingRight = false
	elif(player.getPosition().x - position.x < -100):
		$AnimationPlayer.play("walk")
		motion.x -= moveSpeed			
		facingRight = true
	else:
		$AnimationPlayer.play("idle")
		readyAttack = true
		motion.x = lerp(motion.x,0,1)

func _on_AreaCollide_body_entered(body):
	if(body.has_method("KnockBack")):
		if(body.getPosition().x - position.x < 0):
			body.KnockBack(-1)
		else:
			body.KnockBack(1)
		if(body.has_method("PlayerGetHit")):
			body.PlayerGetHit(5)

func Attack():
	isAttacking = true
	motion.x = lerp(motion.x,0,1)
	SoundManager.play_se("attack")
	$AnimationPlayer.play("attack")
	$TimerAttack.start(1)

func Destroy():
	queue_free()

func _on_VisibilityNotifier2D_screen_entered():
	active = true

func Stop():
	active = false

func _on_TimerAttack_timeout():
	isAttacking = false

func _on_AreaAttack_body_entered(body):
	if(body.has_method("KnockBack")):
		if(body.getPosition().x - position.x < 0):
			body.KnockBack(-1)
		else:
			body.KnockBack(1)
		if(body.has_method("PlayerGetHit")):
			body.PlayerGetHit(10)

func Death():
	motion.y = lerp(motion.y,0,1)
	motion.x = lerp(motion.x,0,1)
	destroyOnce = false
	$CollisionShape2D.queue_free()
	$AreaCollide.queue_free()
	$Knight3Block.visible = false
	$Knight3Idle.visible = false
	$Knight3ImprovedSlashAnimation.visible = false
	$KnightWalkAnimation.visible = false
	

func KnockBack(lr):
	isKnockingBack = true
	$TimerKnock.start(0.3)
	if(lr < 0):
		knockX = abs(knockX) * -1
	else:
		knockX = abs(knockX)
	motion.x = lerp(motion.x, knockX, 0.7)

func _on_TimerKnock_timeout():
	isKnockingBack = false
