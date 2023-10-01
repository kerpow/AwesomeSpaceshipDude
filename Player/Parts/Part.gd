class_name Part
extends Area2D
@onready var projectile_sound = $ProjectileSound
@onready var explosion = $Explosion


@export var damage : int = 1
@export var weight : int = 0
@export var speed : int = 0
@export var rotate : int  = 0
@export var health : int = 0
@export var isStrut : bool = false
@export var cooldownMin: float = .9
@export var cooldownMax: float = 1.1

@export var projectile : PackedScene
@export var projectileSpeed = 800

var cooldownTime: float = 0

var mouseOver = false;
var dragging = false


var mousePos;

@onready var sprite = $Sprite2D

signal PartDestroyed(Vector2)

var attachingTarget: Node2D
	
func _process(delta):


	
	
	if projectile:
		if isAttached() and Input.is_action_pressed("fire") and cooldownTime < 0:
			fire()
			
		if cooldownTime >= 0:
			cooldownTime -= delta
		
func fire():
	
	cooldownTime = randf_range(cooldownMin, cooldownMax)
	var p = projectile.instantiate()
	p.fire(global_position, global_position + -global_transform.y * Vector2.ONE, 1, true)
	get_tree().root.add_child(p)
	projectile_sound.play()

func statsDescription(added: bool):
	
	var direction = "-"
	if added:
		direction = "+"

	
	var result : String  = name + "\n";
	if weight != 0: result+= "Weight %s%s\n" % [direction, weight]
	if speed != 0: result+= "Speed %s%s\n" % [direction, speed]
	if health != 0: result+= "health %s%s\n" % [direction, health]
	if isStrut: result+= "Structure\n"
		
		
	return result
	

func _physics_process(delta):
	
	if dragging:
		global_position = lerp(global_position, get_global_mouse_position(), 25*delta)
		
		checkPlacement()

func checkPlacement():
	var onStrut = false
	var onPart = false
	for i in get_overlapping_bodies() + get_overlapping_areas():
		if i is Player:
			attachingTarget = i
			onStrut = true
		elif i is Part:
			if i.isStrut and i.isAttached():
				onStrut = true
				attachingTarget = i
			else:
				onPart = true
				
	
	if onStrut:
		if onPart:
			sprite.modulate = Color(1,0,0)
			attachingTarget = null
		else:
			sprite.modulate = Color(0,1,0)
	else:
		sprite.modulate = Color(1,1,1)
		attachingTarget = null
			

func _unhandled_input(event):
	
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		if mouseOver and event.button_index == 1 and event.is_pressed():
			dragStart()
			get_viewport().set_input_as_handled()
		elif event.button_index == 1 and event.is_released():
			dragEnd()
			
			

func dragStart():
	dragging = true
	
	if isAttached():
		get_parent().detach(self)

func dragEnd():
	
	dragging = false
	sprite.modulate = Color(1,1,1)
	
	
	if attachingTarget and !isAttached():
		attachingTarget.attach(self)
		

func attach(part: Part):
	part.reparent(self)
	find_parent("Player").addStats(part)
	
func detach(part: Part):
	var p = find_parent("Player")
	if p:
		part.reparent(p.get_parent())
		p.removeStats(part)

func TakeDamage():
	explosion.play()
	if isAttached():
		find_parent("Player").removeStats(self)
		
	PartDestroyed.emit(global_position)
	queue_free()
	
	
		
	
func _on_mouse_entered():
	mouseOver = true;


func _on_mouse_exited():
	mouseOver = false;
	
		
func isAttached() -> bool:
	return get_parent() is Player or get_parent() is Part
