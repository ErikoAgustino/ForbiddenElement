extends Control

func _ready():
	visible = true
	$HP.value = GlobalPlayer.getHp()
	$hpText.text = str($HP.value)
	$Elements.frame = GlobalPlayer.getActiveSkillIndex()
	
func _process(delta):
	$HP.value = GlobalPlayer.getHp()
	$hpText.text = str($HP.value)
	$Elements.frame = GlobalPlayer.getActiveSkillIndex()
