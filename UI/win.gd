extends CanvasLayer

signal PlayEndless



func _on_button_pressed():
	PlayEndless.emit()
