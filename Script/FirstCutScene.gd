extends Node2D

var once = false
var activeOnce = true

func _ready():
	$Canvas/Transition.FadeOut3()
	$Player.setIsActive(false)
	
func _process(delta):
	if(!$Canvas/Transition/AnimationPlayer.is_playing() and activeOnce):
		$Canvas/Dialog.setActive()
		activeOnce = false
		once = true
		
	if(!GlobalPlayer.get_is_DialogActive() and once):
		$Player.setIsActive(true)
		$Rick.Teleport()
		$Canvas/Dialog.queue_free()
		once = false
