# Give the component a class name so it can be instanced as a custom node
class_name DestroyedComponent
extends Node

@onready var animated_sprite_2d: AnimatedSprite2D = get_parent().get_node("AnimatedSprite2D")
@onready var win: CanvasLayer = get_parent().get_parent().get_node("Win")

# Export the actor this component will operate on
@export var actor: Node2D

# Grab access to the stats so we can tell when the health has reached zero
@export var stats_component: StatsComponent

# Export and grab access to a spawner component so we can create an effect on death
@export var destroy_effect_spawner_component: SpawnComponent

func _ready() -> void:
	# Connect the the no health signal on our stats to the destroy function
	stats_component.no_health.connect(destroy)

func destroy() -> void:
	if actor.name == "AnimatedSprite2D":
		actor = actor.get_parent()
	if actor is Boss:
		win.visible = true
		
	if actor.name != "Atilla":
		# create an effect (from the spawner component) and free the actor
		destroy_effect_spawner_component.spawn(actor.global_position)
	animated_sprite_2d.material.set_shader_parameter("shake_power", float(0.0))
	animated_sprite_2d.material.set_shader_parameter("shake_rate", float(0.0))
	animated_sprite_2d.material.set_shader_parameter("shake_color_rate", float(0.0))
	animated_sprite_2d.material.set_shader_parameter("flash_modifier",0)
	Global.kill_count += 1
	
	if actor is Boss:
		await get_tree().create_timer(3).timeout
		get_tree().change_scene_to_file("res://Menu/MenuStart/MenuStart.tscn")
	
	actor.queue_free()
	
