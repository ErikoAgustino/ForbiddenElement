extends Node2D


onready var playerPath = "../../Player"
var player
var poisonPath = preload("res://Prefabs/Enemy/Bullet/Poison.tscn")
var readyAttack
var attackOnce
var attackCd
var hp
var active
var destroyOnce
var checkPlayerLoc

func _ready():
	player = get_node(playerPath)
	readyAttack = false
	active = false
	attackOnce = true
	destroyOnce = true
	attackCd = 3
	hp = 30
	$HP.max_value = hp
	$HP.value = hp
	
func _process(delta):
	if(active and destroyOnce):
		if(!readyAttack):
			$AnimationPlayer.play("idle")
			if(attackCd > 0):
				attackCd -= delta

			IdleAndAttack()

		else:
			if(attackOnce):
				attackCd = 3
				attackOnce = false
				$AnimationPlayer.play("attack")
				$Timer.start(1.1)
	
	$HP.value = hp
	if(hp < 1 and destroyOnce):
		destroyOnce = false
		$AreaBody.queue_free()
		$AreaAttack.queue_free()
		$BlobAttack.visible = false
		$BlobIdle.visible = false
		$Explotion.setExplode()
	
func FlipSprite(bol,x1,x2):
	$BlobAttack.flip_h = bol
	$BlobIdle.flip_h = bol
	$AreaAttack/CollisionShape2D.position.x = x1
	$AreaAttack/CollisionShape2D2.position.x = x2

func IdleAndAttack():
	checkPlayerLoc = player.getPosition().x - position.x
	if(checkPlayerLoc > 50):
		FlipSprite(true,70,130)
		if(checkPlayerLoc < 200):
			if(attackCd < 0):
				readyAttack = true
				attackOnce = true
	elif(player.getPosition().x - position.x < -50):
		FlipSprite(false,-45,-124)
		if(checkPlayerLoc > -200):
			if(attackCd < 0):
				readyAttack = true
				attackOnce = true

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
			body.PlayerGetHit(4)
			var poison = poisonPath.instance()
			body.add_child(poison)


func _on_AreaBody_body_entered(body):
	if(body.has_method("KnockBack")):
		if(body.getPosition().x - position.x < 0):
			body.KnockBack(-1)
		else:
			body.KnockBack(1)
		if(body.has_method("PlayerGetHit")):
			body.PlayerGetHit(5)


func _on_Timer_timeout():
	readyAttack = false
	
func Destroy():
	queue_free()
	
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

func _on_VisibilityNotifier2D_screen_entered():
	active = true

func Stop():
	active = false
