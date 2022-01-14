extends Node



var isSpawnBlink = false
var isSpawnDoubleJump = false
var isSpawnFlameSword = false
var isSpawnBossOne = false
var isSpawnBossTwo = false

func _ready():
	pass
	
func setIsSpawnBlink(bol):
	isSpawnBlink = bol

func getIsSpawnBlink():
	return isSpawnBlink

func setIsSpawnDoubleJump(bol):
	isSpawnDoubleJump = bol

func getIsSpawnDoubleJump():
	return isSpawnDoubleJump
	
func setIsSpawnFlameSword(bol):
	isSpawnFlameSword = bol

func getIsSpawnFlameSword():
	return isSpawnFlameSword
	
func setIsSpawnBossOne(bol):
	isSpawnBossOne = bol

func getIsSpawnBossOne():
	return isSpawnBossOne	

func setIsSpawnBossTwo(bol):
	isSpawnBossTwo = bol
	
func getIsSpawnBossTwo():
	return isSpawnBossTwo

func PlayMusic():
	SoundManager.play_bgm("MainMusic")


