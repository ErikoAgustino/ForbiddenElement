extends Control

func _ready():
	visible = true
	$HP.value = GlobalPlayer.getHp()
	$hpText.text = str($HP.value)
	
func _process(delta):
	$HP.value = GlobalPlayer.getHp()
	$hpText.text = str($HP.value)
