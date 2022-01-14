extends KinematicBody2D

export (bool) var left

var hp
var isAttacking
const tornadoPath = preload("res://Prefabs/Enemy/Bullet/WaterTornado.tscn")
var cd = 0
var checkPlayerLoc
var target
var active
var destroyOnce

func _ready():
	$SorcererVillain.flip_h = left
	active = false
	destroyOnce = true
	cd = 0
	hp = 15
	$HP.max_value = hp
	$HP.value = hp
	
func _process(delta):
	if(active and destroyOnce):
		cd += delta
		if(cd > 4):
			$AnimationPlayer.play("attack")
			$Timer.start(0.9)
			cd = 0
	$HP.value = hp
	
	if(hp < 1 and destroyOnce):
		destroyOnce = false
		$CollisionShape2D.queue_free()
		$Area2D.queue_free()
		$SorcererVillain.visible = false
		$Explotion.setExplode()
	
func Attack():
	var tempPos = position
	tempPos.y = 0
	
	if(left):
		tempPos.x -= 100
		target = Vector2(-1,0)
	else:
		tempPos.x += 100
		target = Vector2(1,0)
	
	var att = tornadoPath.instance()
	get_parent().add_child(att)

	att.setPosition(tempPos)
	att.setMotion(target)

func _on_VisibilityNotifier2D_screen_entered():
	active = true

func _on_VisibilityNotifier2D_screen_exited():
	active = false

func _on_Timer_timeout():
	Attack()

func _on_Area2D_body_entered(body):
	if(body.has_method("KnockBack")):
		if(body.getPosition().x - position.x < 0):
			body.KnockBack(-1)
		else:
			body.KnockBack(1)
		if(body.has_method("PlayerGetHit")):
			body.PlayerGetHit(2)
		
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
	
func Destroy():
	queue_free()
