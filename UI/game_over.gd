extends CanvasLayer

signal Retry()



func _on_button_pressed():
	print("pressed")
	Retry.emit()
