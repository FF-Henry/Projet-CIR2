extends CharacterBody2D

@export var stats: EnnemiesStatsComponent
@export var hurtbox_component: HurtboxComponent

var speed: float = 30.0
var direction : Vector2

const expScene = preload("res://experience/experience.tscn")

@onready var atk_1: AudioStreamPlayer2D = $atk_1
@onready var atk_2: AudioStreamPlayer2D = $atk_2
@onready var atk_3: AudioStreamPlayer2D = $atk_3


@onready var detection_r: CollisionShape2D = $range/DetectionR
@onready var detection_l: CollisionShape2D = $range/DetectionL
@onready var range: Area2D = $range
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var player = get_node("/root/World/Bob")
@onready var wait_timer: Timer = $Timer
@onready var attack_l: CollisionShape2D = $HitboxComponent/AttackL
@onready var attack_r: CollisionShape2D = $HitboxComponent/AttackR

var wait : bool = false
var in_area : bool = false
var walk_time : bool = true
var just_cancelled : bool = false
var timer : Timer

func _ready():
	attack_l.set_deferred("disabled", true)
	attack_r.set_deferred("disabled", true)
	var attackInterval = stats.ATK_SPEED
	wait_timer.wait_time = attackInterval / 50
	range.body_entered.connect(_on_range_body_entered)
	range.body_exited.connect(_on_range_body_exited)
	timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = 0.5
	timer.timeout.connect(cancel_remove)
	add_child(timer)


func attack() -> void:
	var nb_random = randi() % 3 + 1
	animated_sprite_2d.play("attack")
	match nb_random:
		1:
			atk_1.play()
		2:
			atk_2.play()
		3:
			atk_3.play()
	wait = true
	await animated_sprite_2d.animation_finished
	if in_area:
		attack_l.set_deferred("disabled", true)
		attack_r.set_deferred("disabled", true)
		wait_timer.start()
	else:
		wait = false


func _physics_process(delta):
	if(!wait):
		attack_l.set_deferred("disabled", true)
		attack_r.set_deferred("disabled", true)
		animated_sprite_2d.play("move")
		if not(just_cancelled):
			direction = global_position.direction_to(player.global_position)
			velocity = direction * speed * delta 
			move_and_collide(velocity)
		else:
			animated_sprite_2d.frame = 0
	
		if direction.x < 0:
			animated_sprite_2d.flip_h = true
			detection_r.disabled = true
			detection_l.disabled = false
			
		else:
			animated_sprite_2d.flip_h = false
			detection_r.disabled = false
			detection_l.disabled = true
	else:
		if animated_sprite_2d.frame == 3:
			if direction.x > 0:
				attack_r.set_deferred("disabled", false)
			else:
				attack_l.set_deferred("disabled", false)

func _on_range_body_entered(_body):
	attack()
	in_area = true
	
func _on_range_body_exited(_body):
	in_area = false

func _hurt() -> void:
	animated_sprite_2d.stop()
	wait = false

func _on_timer_timeout() -> void:
	wait = false
	if in_area:
		attack()

func _on_stats_component_health_changed() -> void:
	timer.start(0.5)
	just_cancelled = true
	wait = false

func cancel_remove():
	just_cancelled = false
