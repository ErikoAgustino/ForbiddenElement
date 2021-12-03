extends KinematicBody2D

const bulletPath = preload("res://Prefabs/Enemy/Bullet/TurretBullet.tscn")
var cd = 0
var active = false
export(NodePath) var playerPath = "../Player"
var player
var hp = 10
var destroyOnce = true


func _ready():
	$Sprite/AnimationPlayer.play("idle")
	$HP.max_value = hp
	$HP.value = hp
	player = get_node(playerPath)
	
func _process(delta):
	$HP.value = hp
	if(active and destroyOnce):
		if((player.getPosition().x - position.x) < -60):
			cd += delta
			if(cd > 2):
				ShootProjectile()
				cd = 0
				
			elif($Sprite/AnimationPlayer.current_animation != "shoot"):
				$Sprite/AnimationPlayer.play("idle")
				
	if(hp < 1 and destroyOnce):
		destroyOnce = false
		$AreaCollide.queue_free()
		$CollisionShape2D.queue_free()
		$Sprite.visible = false
		$Explotion.setExplode()


func ShootProjectile():
	$Sprite/AnimationPlayer.play("shoot")
	var bullet = bulletPath.instance()
	
	get_parent().add_child(bullet)
	bullet.setPosition(Vector2(position.x-80, position.y))
	
	bullet.setMotion(player.getPosition() - bullet.position)


func _on_VisibilityNotifier2D_screen_entered():
	active = true
	
func MeleeHitColide(dmg):
	hp -= dmg
	
func ElementHitColide(dmg,type):
	hp -= dmg
	
func CounterHit():
	hp = 0

func Destroy():
	queue_free()

func Stop():
	active = false

func _on_VisibilityNotifier2D_screen_exited():
	active = false


func _on_AreaCollide_body_entered(body):
	if(body.has_method("KnockBack")):
		if(body.getPosition().x - position.x < 0):
			body.KnockBack(-1)
		else:
			body.KnockBack(1)
		if(body.has_method("PlayerGetHit")):
			body.PlayerGetHit(2)
