extends KinematicBody2D

const bulletPath = preload("res://Prefabs/Enemy/Bullet/RobotBullet.tscn")

var dropItem = true
onready var playerPath = "../../Player"
var player
var me
var motion = Vector2()
const up = Vector2(0,-1)
var maxMoveSpeed = 100
var moveSpeed = 70
var gravity = 80
var maxFallSpeed = 500
var isGravity = false
var active = false
var elementReaction
var hp
var cdAtk = 0
var destroyOnce = true
var readyAttack
var isAttacking = false
var isKnockingBack
var knockX = 500
var poisonPath = preload("res://Prefabs/Enemy/Bullet/Poison.tscn")

func _ready():
	$Explotion.setSpawnItem(dropItem)
	hp = 50
	$HP.max_value = hp
	$HP.value = hp
	readyAttack = false
	isKnockingBack = false
	player = get_node(playerPath)
			
func _physics_process(delta):
	if(active and destroyOnce and !isKnockingBack):
		me = get_position()
		
		if(!isAttacking):
			EnemyMovement()
	
		if(readyAttack):	
			cdAtk += delta
			if(cdAtk > 0.5):
				Attack()
				readyAttack = false
				cdAtk = 0
		else:
			cdAtk = 0
		
	motion = move_and_slide(motion,up)
	$HP.value = hp
	
	if(destroyOnce):
		FallGravity()
			
	if(hp < 1 and destroyOnce):
		Death()

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

func EnemyMovement():
	
	motion.x = clamp(motion.x,-maxMoveSpeed,maxMoveSpeed)

	if(player.getPosition().x - me.x > 130):
		motion.x += moveSpeed
		$Sprite.flip_h = true
		$SpriteAttack.flip_h = true
		$SpriteWalk.flip_h = true
		$AnimationPlayer.play("walk")
		readyAttack = false
		$AreaAttack/CollisionShape2D.position.x = 95
	elif(player.getPosition().x - me.x < -130):
		motion.x -= moveSpeed
		$Sprite.flip_h = false
		$SpriteAttack.flip_h = false
		$SpriteWalk.flip_h = false
		$AnimationPlayer.play("walk")
		readyAttack = false
		$AreaAttack/CollisionShape2D.position.x = -95
	else:
		$AnimationPlayer.play("idle")
		readyAttack = true
		motion.x = lerp(motion.x,0,0.7)


func _on_AreaCollide_body_entered(body):
	if(body.has_method("KnockBack")):
		if(body.getPosition().x - position.x < 0):
			body.KnockBack(-1)
		else:
			body.KnockBack(1)
		if(body.has_method("PlayerGetHit")):
			body.PlayerGetHit(5)


func Attack():
	$AnimationPlayer.play("Attack")
	isAttacking = true
	
	$Timer.start(0.8)
	
func getPlayerPos():
	return player.getPosition()

func Destroy():
	queue_free()

func _on_VisibilityNotifier2D_screen_entered():
	active = true

func Stop():
	active = false

func _on_AreaAttack_body_entered(body):
	if(body.has_method("KnockBack")):
		if(body.getPosition().x - position.x < 0):
			body.KnockBack(-1)
		else:
			body.KnockBack(1)
		if(body.has_method("PlayerGetHit")):
			for child in body.get_children():
				if(child.name == "Poison"):
					return
			body.PlayerGetHit(6)
			var poison = poisonPath.instance()
			body.add_child(poison)

func _on_Timer_timeout():
	isAttacking = false

func Death():
	motion.y = lerp(motion.y,0,1)
	motion.x = lerp(motion.x,0,1)
	destroyOnce = false
	$CollisionShape2D.queue_free()
	$AreaCollide.queue_free()
	$AreaAttack.queue_free()
	$Sprite.visible = false
	$SpriteAttack.visible = false
	$SpriteWalk.visible = false
	$Explotion.setExplode()

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

func setDropItem(bol):
	dropItem = bol
