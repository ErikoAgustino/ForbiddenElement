extends Label


var travel = Vector2(0,-80)
var duration = 2
var spread = PI/2

func ShowDamage(value):
	text = str(value)
	var movement = travel.rotated(rand_range(-spread/2, spread/2))
	rect_pivot_offset = rect_size / 2
	$Tween.interpolate_property(self, "rect_position",
			rect_position, rect_position + movement,
			duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(self, "modulate:a",
			1.0, 0.0, duration,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()	


func _on_Tween_tween_all_completed():
	queue_free()
