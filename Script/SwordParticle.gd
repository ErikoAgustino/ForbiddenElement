extends Node2D

func _ready():
	$particle.emitting = true

func setPosition(pos):
	position = pos
	
func _process(delta):
	if(!$particle.emitting):
		queue_free()
