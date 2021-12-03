extends KinematicBody2D

const bulletPath = preload("res://Prefabs/Enemy/Bullet/TurretBulletDummy.tscn")
var cd = 0
var active = false
var playerPath = "../Player"
var player
var hp = 10
var destroyOnce = true


func _ready():
	player = get_node(playerPath)
	$Sprite/AnimationPlayer.play("idle")
	$HP.max_value = hp
	$HP.value = hp
	
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

