
extends KinematicBody2D

const bulletPath = preload("res://Prefabs/Enemy/Bullet/RobotBullet.tscn")

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
var cdAtk = 0
var destroyOnce = true

func _ready():
	hp = 10
	$HP.max_value = hp
	$HP.value = hp
	frozen = false
	facingRight = true
	elementReaction = get_node("Reaction")
	
func _physics_process(delta):
	if(active and not frozen and destroyOnce):
		player = get_parent().get_node("Player")
		me = get_position()
		$Sprite/AnimationPlayer.play("idle")
		EnemyMovement()
		
		"""
		cdAtk += delta
		if(cdAtk > 1):
			cdAtk = 0
		"""
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
		get_node("Reaction").setFrozen()
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
		$Sprite.flip_h = true
	elif(player.getPosition().x - me.x < -200):
		motion.x -= moveSpeed
		$Sprite.flip_h = false			
		facingRight = true
	else:
		motion.x = lerp(motion.x,0,0.7)

func _on_Frozen_timeout():
	get_node("Reaction/Frozen").visible = false
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
	print("Ok")
	active = false
	motion.x = lerp(motion.x ,0, 1)

func getPlayerPos():
	return player.getPosition()

func Destroy():
	var flamesword = load("res://Prefabs/InventoryItems/FlameSword.tscn").instance()
	var container = load("res://Prefabs/InventoryItems/PickcableContainer.tscn").instance()
	
	container.add_child(flamesword)
	container.setItem(flamesword)
	container.setPosition(position)
	get_parent().add_child(container)
	queue_free()

func _on_VisibilityNotifier2D_screen_entered():
	active = true
