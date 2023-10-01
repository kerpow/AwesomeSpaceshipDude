class_name  Level
extends Node2D
@onready var part_explosion = $PartExplosion
@onready var enemy_explosion = $EnemyExplosion


@onready var notice = $Notice
@onready var enemies = $World/Enemies
@onready var initial_parts = $World/InitialParts
@onready var spawners = $World/Spawners

@onready var waves = $Waves
var currentWave: int
var totalWaves : int
var enemiesRemaining: int

@onready var start = $Start
@onready var ui : UI = $UI
@onready var wave_intro : WaveIntro = $WaveIntro
@onready var game_over = $GameOver
@onready var win = $Win

var isEndless = false
var player : Player

var score : int = 0

var parts : Array[PackedScene]
var endlessEnemies : Array[PackedScene]



func _ready():
	LoadWaves()
	SetupParts()
	SetupEnemies()
	SetupPlayer()
	SetupUI()

func SetupUI():
	start.show()
	ui.hide()
	wave_intro.hide()
	game_over.hide()
	win.hide()
		
func SetupPlayer():
	player = find_child("Player")
	player.PartAttached.connect(onPartAttached)
	player.PartDetached.connect(onPartDetached)
	player.Died.connect(onPlayerDied)
	
	
	for i in initial_parts.get_children():
		i.PartDestroyed.connect(onPartDestroyed)
	
func loadWave(v:int):
	var wave : Wave = waves.get_child(v)
	
	wave_intro.showText(wave.introduction)
	ui.showWave(v + 1, totalWaves) 
	for x in wave.fast: 
		SpawnEnemy(preload("res://Enemies/fastAlien.tscn"))
	for x in wave.slow: 
		SpawnEnemy(preload("res://Enemies/slowAlien.tscn"))
	for x in wave.rock: 
		SpawnEnemy(preload("res://Enemies/rock.tscn"))
	
	
func LoadWaves():
	totalWaves = waves.get_child_count()
	
func onPartDestroyed(_pos):
	part_explosion.global_position = player.global_position
	part_explosion.play()
	checkPityPart()
	

func onPartAttached(_player, part):
	notice.PartAttached(part)
	
func onPartDetached(_player, part):
	notice.PartDetached(part)

func onPlayerDied():
	game_over.show()

func SetupEnemies():
	endlessEnemies.append(preload("res://Enemies/fastAlien.tscn"))

func SetupParts():
	parts.append(preload("res://Player/Parts/laser_blaster.tscn"))
	parts.append(preload("res://Player/Parts/laser_blaster.tscn"))
	parts.append(preload("res://Player/Parts/laser_blaster.tscn"))
	parts.append(preload("res://Player/Parts/strut1.tscn"))
	parts.append(preload("res://Player/Parts/thruster.tscn"))
	parts.append(preload("res://Player/Parts/thruster.tscn"))

func _on_enemy_died(pos: Vector2, s : int):
	spawnPart(pos)
	score+=s
	ui.showScore(score) 
	enemy_explosion.global_position = player.global_position
	enemy_explosion.play()
	
	
	if isEndless:
		SpawnRandomEnemy()
	else:
		enemiesRemaining-=1
		if enemiesRemaining == 0:
			print("current wave %s total %s" % [currentWave, totalWaves])
			if currentWave < totalWaves - 1:
				loadWave(currentWave + 1)
			else:
				Win()

func Win():
	win.show()
	

		

func spawnPart(pos : Vector2):
	var p = parts.pick_random().instantiate()
	initial_parts.add_child(p)
	p.global_position = pos
	
func pickNodeAwayFromPlayer() -> Node2D:
	var node : Node2D= spawners.get_children().pick_random()
	if player.global_position.distance_to(node.global_position) < 2000:
		return pickNodeAwayFromPlayer()
	return node
	
func SpawnRandomEnemy():
	var e = endlessEnemies.pick_random()
	SpawnEnemy(e)
	
	
func SpawnEnemy(enemyScene : PackedScene):
	var farNode = pickNodeAwayFromPlayer()
	
	var e = enemyScene.instantiate()
	e.global_position = farNode.global_position
	e.Died.connect(_on_enemy_died)
	enemies.add_child(e)
	enemiesRemaining+=1




func _on_start_start():
	start.hide()
	wave_intro.show()
	ui.show()
	loadWave(0)

func checkPityPart():
	
	if get_tree().get_nodes_in_group("weapon").size() <= 1:
		var farNode = pickNodeAwayFromPlayer()
		
		var blaster = preload("res://Player/Parts/laser_blaster.tscn")
		var b = blaster.instantiate()
		
		initial_parts.add_child(b)
		b.global_position = farNode.global_position
	


func _on_game_over_retry():
	get_tree().reload_current_scene()


func _on_win_play_endless():
	isEndless = true
	win.hide()
	for x in 10:
		SpawnRandomEnemy()
	ui.hideWave()
	
