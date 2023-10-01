class_name UI
extends CanvasLayer

@onready var wave = $MarginContainer/HBoxContainer/VBoxContainer/Wave
@onready var score = $MarginContainer/HBoxContainer/VBoxContainer/Score


func showWave(v, t):
	wave.text = "Wave: %s/%s" % [v,t]
	
func showScore(v):
	score.text = "Score: %s" % v

func hideWave():
	wave.hide()
