extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func _on_bounce_body_entered(body : RigidBody2D):
	
	#body.apply_impulse(-body.linear_velocity * 1)
