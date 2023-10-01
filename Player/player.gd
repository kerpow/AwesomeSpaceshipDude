class_name Player
extends RigidBody2D
@onready var engine_noises = $EngineNoises


@export var baseSpeed = 0
@export var maxSpeed = 1000
@export var baseRotate = 4000
@export var maxHealth = 10
@export var currentHealth = 10

@export var speed = 5
@export var rotate = 4000
@export var health = 10
@export var damage = 1

signal PartAttached(player, part)
signal PartDetached(player, part)
signal Foo (hey)
signal Died(Player)

func TakeDamage(_v: int):
	#drop a non strut
	for i in get_children():
		if i is Part:
			if !i.isStrut:
				i.TakeDamage()
				return
				
				
	#drop a  strut
	for i in get_children():
		if i is Part:
			if i.isStrut:
				i.TakeDamage()
				return
				
	#game over
	die()

func die():
	Died.emit()
	
	$Sprite2D.hide()
	
	
func _ready():
	speed = baseSpeed
	rotate = baseRotate

func _physics_process(delta):
	if currentHealth <=0:
		return
		
	apply_torque(Input.get_axis("left", "right") * rotate * delta)
	

	
	if(Input.is_action_pressed("up")):
		if !engine_noises.playing:
			engine_noises.play()
		if linear_velocity.length() < maxSpeed:
			apply_impulse(-transform.y * speed * delta)
	else:
		engine_noises.stop()
		

func addStats(part : Part):
	speed += part.speed
	rotate += part.rotate
	currentHealth += part.health
	maxHealth += part.health
	
	PartAttached.emit(self, part)
	
func removeStats(part : Part):
	speed -= part.speed
	rotate -= part.rotate
	currentHealth -= part.health
	maxHealth -= part.health
	
#	PartDetached.emit(self, part)
	
func attach(part: Part):
	part.reparent(self)
	addStats(part)
	
	
func detach(part: Part):
	part.reparent(get_parent())
	removeStats(part)
	

	
