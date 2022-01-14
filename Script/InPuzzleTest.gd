extends Sprite


var ready = false

func _ready():
	visible = false

func SwitchAction():
	ready = true
	
func SwitchActionR():
	ready = false	
	
func getIsRunning():
	return get_parent().getIsAnimationPlaying()

func getOn():
	return ready
