extends Control


func _ready():
	$InteractButton.visible = false
	$SkillCd.visible = false
	$DashButton.visible = GlobalPlayer.getIsBlinkActive()
	GlobalPlayer.connect("DashActive", self, "OnDashActive")
	GlobalPlayer.connect("OnDetectObject",self, "setInteractObject")
	GlobalPlayer.connect("SkillColdDown", self, "ColdDownSkill")

func OnDashActive():
	$DashButton.visible = true

func setInteractObject(bol):
	$InteractButton.visible = bol
	
func ColdDownSkill(cd):
	if(cd > 0):
		$SkillButton.visible = false
		$SkillCd.visible = true
		$SkillCd/RichTextLabel.bbcode_text = "[center]" + str(stepify(cd, 0.1)) + "[/center]"
	else:
		$SkillButton.visible = true
		$SkillCd.visible = false

func _on_InteractButton_pressed():
	SoundManager.play_se("pickup")
