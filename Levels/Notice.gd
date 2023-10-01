class_name Notice
extends Node2D

@onready var partAttachedModulate = $CanvasModulate
@onready var partAttachedLabel : Label= $CanvasModulate/Label


func PartAttached(part: Part):
	
	global_position = part.global_position
	var tween = get_tree().create_tween()
	tween.tween_property($CanvasModulate, "modulate", Color(1,1,1,1), .25)
	partAttachedLabel.text = part.statsDescription(true)
	
func PartDetached(_part: Part):
	var tween = get_tree().create_tween()
	
	tween.tween_property($CanvasModulate, "modulate", Color(0,0,0,0), .25)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	partAttachedLabel.text = ""
	$CanvasModulate.modulate = Color(0,0,0,0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
