
extends KinematicBody2D

const bulletPath = preload("res://Prefabs/Enemy/Bullet/RobotBullet.tscn")

onready var playerPath = "../../Player"

export (int) var maxFly = -200
export (int) var minDive = -20

var player
var me
var motion = Vector2()
const up = Vector2(0,-1)
var maxMoveSpeed = 100
var moveSpeed = 70
var gravity = 80
var maxFallSpeed = 500
var isGravity = false
var active
var hp
var readyToDive = false
var cdAtk = 0
var destroyOnce = true
var onAttack = false
var onGoingUp = false
var knockX = 500
var isKnockingBack = false

func _ready():
	hp = 20
	$HP.max_value = hp
	$HP.value = hp
	player = get_node(playerPath)
	
func _physics_process(delta):
	if(active and destroyOnce and !isKnockingBack):

		me = get_position()
		$Sprite/AnimationPlayer.play("idle")
		EnemyMovement()
		
		if(readyToDive):
			cdAtk += delta
		if(cdAtk > 0.8 or onAttack):
			DiveAttack()
			cdAtk = 0
		if(onGoingUp):
			Fly()
		
	if(!active):
		$Sprite/AnimationPlayer.stop()

	motion = move_and_slide(motion,up)
	$HP.value = hp
			
	if(hp < 1 and destroyOnce):
		motion.y = lerp(motion.y,0,1)
		motion.x = lerp(motion.x,0,1)
		destroyOnce = false
		$CollisionShape2D.queue_free()
		$AreaCollide.queue_free()
		$Sprite.visible = false
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

func EnemyMovement():
	motion.x = clamp(motion.x,-maxMoveSpeed,maxMoveSpeed)
	if(!onAttack):
		if(player.getPosition().x - me.x > 100):
			motion.x += moveSpeed

			$Sprite.flip_h = true
			readyToDive = false
		elif(player.getPosition().x - me.x < -100):
			motion.x -= moveSpeed
			$Sprite.flip_h = false			
			readyToDive = false
		else:
			motion.x = lerp(motion.x,0,0.7)
			readyToDive = true
	else:
		if($Sprite.flip_h):
			motion.x += moveSpeed
		else:
			motion.x -= moveSpeed
	
func _on_AreaCollide_body_entered(body):
	if(body.has_method("KnockBack")):
		if(body.getPosition().x - position.x < 0):
			body.KnockBack(-1)
		else:
			body.KnockBack(1)
		if(body.has_method("PlayerGetHit")):
			body.PlayerGetHit(5)

func Stop():
	active = false
	motion.x = lerp(motion.x ,0, 1)

func getPlayerPos():
	return player.getPosition()

func Destroy():
	queue_free()

func _on_VisibilityNotifier2D_screen_entered():
	active = true
	
func DiveAttack():
	onAttack = true
	
	motion.y = lerp(300,100,0.2 )
	
	if(position.y > minDive):
		motion.y = lerp(0,0,1)

		onGoingUp = true
		
func Fly():
	motion.y = lerp(-300,-100,0.2 )
	
	if(position.y < maxFly):
		motion.y = lerp(0,0,1)
		onAttack = false
		onGoingUp = false
		

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
