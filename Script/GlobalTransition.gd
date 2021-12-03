extends Node2D

func _ready():
	$Canvas/Transition.FadeOut()
	
	"""
	if(has_node("AudioStreamPlayer2D")):
		$AudioStreamPlayer2D.play()
	"""
