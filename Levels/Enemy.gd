class_name Enemy

extends RigidBody2D
@onready var explosion = $Explosion

@export var score : int = 100
@export var projectile : PackedScene
@export var projectileSpeed : int
@export var speed: int
@export var maxSpeed: int = 500
@export var fireDistance: int
@export var runDistance: int
@export var damage : int = 1
@export var health : int = 1
@export var collisionDamage: bool = false
var player : Player

@export var fireRate : float = .5
var cooldown : float = 0
@onready var turret = $Turret

signal Died(Vector2, int)

func TakeDamage(v: int):
	health -= v
	if health <= 0:
		explosion.play()
		Died.emit(global_position, score)
		queue_free()
		
	
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
	body_entered.connect(on_body_entered)
	
func _physics_process(delta):
	if player != null and player.health > 0:
		var distance = global_position.distance_to(player.global_position)
		var direction = (player.global_position - global_position).normalized()
		turret.rotation = (direction).normalized().angle() 
		
		if cooldown >= 0:
			cooldown -= delta
			
		
		if distance > fireDistance:
			if linear_velocity.length() < maxSpeed:
				apply_impulse(direction * delta * speed)
		else:
			fire()
		
		if distance < runDistance:
			if linear_velocity.length() < maxSpeed:
				apply_impulse(-direction * delta * speed)

func fire():
	if projectile and cooldown < 0:
		cooldown = fireRate
		var p = projectile.instantiate()
		p.fire(global_position, player.global_position, 1, false)
		get_tree().root.add_child(p)

func on_body_entered(other : Node):
	if other is Player:
		other.TakeDamage(1)


