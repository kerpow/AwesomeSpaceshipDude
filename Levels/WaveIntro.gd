class_name WaveIntro 
extends CanvasLayer

@onready var label = $Label


func showText(v: String):
	
	label.text = v
	label.global_position.x = -500
	var tween = get_tree().create_tween()
	tween.tween_property($Label, "global_position:x", 326, .25)
	tween.tween_interval(4)
	tween.tween_property($Label, "global_position:x", 1152, .25)
	
