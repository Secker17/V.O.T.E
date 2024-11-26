extends CharacterBody3D

@export var speed: float = 2.0
@export var area_size: Vector3 = Vector3(10, 0, 10)  # Størrelsen på området fienden kan bevege seg i
@export var idle_time: float = 2.0  # Tid fienden venter mellom bevegelsene

var target_position: Vector3 = Vector3.ZERO
var timer: float = 0.0

func _ready():
	set_random_target()

func _physics_process(delta):
	# Beveg karakteren mot målet
	if global_transform.origin.distance_to(target_position) > 0.5:
		move_towards_target(delta)
	else:
		# Vent før den velger et nytt mål
		timer -= delta
		if timer <= 0.0:
			set_random_target()

func set_random_target():
	# Generer et tilfeldig mål innenfor områdegrensene
	var random_x = randf() * area_size.x - area_size.x / 2
	var random_z = randf() * area_size.z - area_size.z / 2
	target_position = Vector3(random_x, global_transform.origin.y, random_z)
	timer = idle_time  # Sett ventetid før neste bevegelse

func move_towards_target(delta):
	# Finn retningen og beveg mot målet
	var direction = (target_position - global_transform.origin).normalized()
	velocity = direction * speed
	move_and_slide()
