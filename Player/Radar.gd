extends Node2D

@export var group : String
@export var minRange = 500

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var closestDistance = 1.79769e308
	var closestNode : Node2D
	var nodes =  get_tree().get_nodes_in_group(group)
	
	if nodes.size() == 0:
		return
		
		
	for e in nodes:
		var distance = global_position.distance_to(e.global_position) 
		if !(e is Part and e.isAttached()) and distance < closestDistance:
			closestDistance = distance
			closestNode = e
			
	if closestNode and minRange < closestDistance:
		global_rotation = (closestNode.global_position - global_position).angle() + Vector2.DOWN.angle()

		show()
	else:
		hide()
