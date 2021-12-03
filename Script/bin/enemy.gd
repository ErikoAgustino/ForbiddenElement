extends KinematicBody2D

var player
var me
var facingRight = true
var motion = Vector2()
const up = Vector2(0,-1)
var maxMoveSpeed = 60
var moveSpeed = 20

func _ready():
	pass
	
func _physics_process(delta):
	player = get_node("../player").get_position()
	me = get_position()
	$AnimationPlayer.play("idle")
	#EnemyMovement()
	motion = move_and_slide(motion,up)
	

func EnemyAnimation():
	if(abs(player.x - me.x) < 80):
		$AnimationPlayer.play("atk")
	else:
		$AnimationPlayer.play("idle")
	
func EnemyMovement():
	if(facingRight):
		$Sprite.flip_h = false
	else:
		$Sprite.flip_h = true
	
	motion.x = clamp(motion.x,-maxMoveSpeed,maxMoveSpeed)
	
	if(player.x - me.x > 70):
		motion.x += moveSpeed
		facingRight = false
	elif(player.x - me.x < -70):
		motion.x -= moveSpeed			
		facingRight = true
		
