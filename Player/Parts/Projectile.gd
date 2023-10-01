class_name Projectile

extends Area2D

var damage: int
@export var speed : int = 100

var hitsEnemies : bool = false

var aliveTime = 0
var maxAliveTime = 2
# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(on_body_entered)
	area_entered.connect(on_area_entered)

func _physics_process(delta):
	global_position += -global_transform.y * speed * delta
	
func fire(start : Vector2, destination : Vector2, dmg: int, playerShot: bool):
	hitsEnemies = playerShot
	damage = dmg
	global_position = start
	global_rotation = (destination -start ).angle() + Vector2.DOWN.angle()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	aliveTime += delta
	if aliveTime > maxAliveTime:
		queue_free()

func on_body_entered(other: Node):
	call_deferred("checkHit", other)

		
func on_area_entered(other: Node):
	call_deferred("checkHit", other)

func checkHit(other : Node):
	
	
	if hitsEnemies and other is Enemy:
		other.TakeDamage(damage)
		queue_free()
	if !hitsEnemies:
		if other is Player:
			other.TakeDamage(damage)
			queue_free()
		if other is Part:
			other.TakeDamage()
			queue_free()
			
