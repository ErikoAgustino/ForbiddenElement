extends Area2D

var enemyBoss
var active

func _ready():
	if(!GlobalMap.getIsSpawnBossTwo()):
		enemyBoss = get_parent().get_node("../Enemy/EnemyMage")
		active = false
	else:
		queue_free()
		
func _process(delta):
	if(active):
		if(!GlobalPlayer.get_is_DialogActive()):
			enemyBoss.setIsActive(true)
			get_parent().get_node("portal").setIsActive(false)
			queue_free()
			
func _on_Area2D_body_entered(body):
	if(body.name == "Player"):
		ShowDialog()

func ShowDialog():
	active = true
	get_parent().get_node("../Canvas/Dialog").setActive()
			
