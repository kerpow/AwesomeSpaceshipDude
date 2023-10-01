extends CanvasLayer

signal Start()



func _on_button_pressed():
	Start.emit()
