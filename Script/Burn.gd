extends Node2D

var timehit = 0

func _ready():
	$TimerBurn.start(3)
	
func _process(delta):
	timehit += delta
	if(timehit > 0.5):
		get_parent().MeleeHitColide(1)
		timehit = 0

func _on_TimerBurn_timeout():
	queue_free()
