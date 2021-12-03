extends KinematicBody2D



const bulletPath = preload("res://Prefabs/Enemy/Bullet/ProjectileDavid.tscn")

var player
var me
var facingRight
var motion = Vector2()
const up = Vector2(0,-1)
var maxMoveSpeed = 100
var moveSpeed = 70
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
		player = get_node("../Player")
		me = get_position()
		$AnimationPlayer.play("run")
		EnemyMovement()
		
		cdAtk += delta
		if(cdAtk > 5):
			ShootProjectile()
			cdAtk = 0
			
	if(get_slide_count() > 0):
		var player = get_slide_collision(0).collider
		if(player.has_method("KnockBack")):
			if(player.getPosition().x - position.x > 0):
				player.KnockBack(1)
			else:
				player.KnockBack(-1)
	
	motion = move_and_slide(motion,up)
	$HP.value = hp
	
	if(hp < 1 and destroyOnce):
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
		
func ElementHitColide(dmg):
	hp -= dmg
	for x in get_slide_count():
		if(get_slide_collision(x).collider.name == "Fireball" or get_slide_collision(x).collider.name.substr(1,8) == "Fireball"):
			#GlobalPlayer.addHp(5)
			#queue_free()
			Reaction(elementReaction.ApplyElement("fire"))

		elif(get_slide_collision(x).collider.name == "IceBullet" or get_slide_collision(x).collider.name.substr(1,9) == "IceBullet"):
			Reaction(elementReaction.ApplyElement("ice"))
		elif(get_slide_collision(x).collider.name == "WaterBall" or get_slide_collision(x).collider.name.substr(1,9) == "WaterBall"):
			Reaction(elementReaction.ApplyElement("water"))			

func Reaction(reaction):
	if(reaction == "frozen"):
		get_node("Reaction/Frozen").visible = true
		frozen = true
		$AnimationPlayer.stop()
		$Timer.start(3)
	elif(reaction == "vaporize"):
		hp -= 1
	elif(reaction == "melt"):
		$Timer.start(0.1)
		hp -= 2
		
	
func EnemyMovement():
	if(facingRight):
		$Sprite.flip_h = false
	else:
		$Sprite.flip_h = true
	
	motion.x = clamp(motion.x,-maxMoveSpeed,maxMoveSpeed)
	
	if(player.getPosition().x - me.x > 200):
		motion.x += moveSpeed
		facingRight = false
	elif(player.getPosition().x - me.x < -200):
		motion.x -= moveSpeed			
		facingRight = true
	else:
		$AnimationPlayer.stop()
		$Sprite.frame = 12
		motion.x = lerp(motion.x,0,0.7)

func _on_Frozen_timeout():
	get_node("Reaction/Frozen").visible = false
	frozen = false


func ShootProjectile():
	var bullet = bulletPath.instance()
				
	get_parent().add_child(bullet)
	bullet.position = position
	bullet.position.x -= 50
	
	bullet.motion = player.getPosition() - bullet.position

func getPlayerPos():
	return player.getPosition()

func Destroy():
	queue_free()

func _on_VisibilityNotifier2D_screen_entered():
	active = true
