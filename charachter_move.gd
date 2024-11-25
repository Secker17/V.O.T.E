extends CharacterBody3D

@export var speed: float = 5.0  # Bevegelseshastighet
@export var jump_velocity: float = 4.5  # Hoppstyrke
@export var mouse_sensitivity: float = 0.2  # Følsomhet for musens bevegelse

var yaw: float = 0.0  # Rotasjon på Y-aksen (horisontal rotasjon)
var pitch: float = 0.0  # Rotasjon på X-aksen (vertikal rotasjon)

func _ready() -> void:
	# Sett musemodusen til synlig som standard
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.is_action_pressed("mouse_look"):
			# Beregn ny rotasjon basert på musens bevegelser
			yaw -= event.relative.x * mouse_sensitivity
			pitch -= event.relative.y * mouse_sensitivity

			# Begrens pitch for å unngå ekstrem rotasjon
			pitch = clamp(pitch, -89.0, 89.0)

			# Oppdater rotasjonen for karakteren
			rotation_degrees = Vector3(pitch, yaw, 0.0)

		else:
			# Sett musemodus tilbake til synlig når museknappen slippes
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta: float) -> void:
	# Legg til tyngdekraft hvis karakteren ikke står på bakken
	if not is_on_floor():
		velocity.y += ProjectSettings.get_setting("physics/3d/default_gravity") * delta

	# Hopp når spilleren trykker på "ui_accept" (vanligvis mellomromstasten)
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Bevegelse ved hjelp av tastaturet
	var input_dir = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()

	if input_dir.length() > 0:
		# Konverter 2D-input til 3D-retning basert på karakterens rotasjon
		var forward = -global_transform.basis.z.normalized()  # Framme
		var right = global_transform.basis.x.normalized()  # Høyre
		var direction = (forward * input_dir.y + right * input_dir.x).normalized()  # Bevegelsesretning
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		# Reduser bevegelsen gradvis når ingen input gis
		velocity.x = lerp(velocity.x, 0, 0.1)
		velocity.z = lerp(velocity.z, 0, 0.1)

	# Utfør bevegelse og oppdater `velocity`
	move_and_slide()  # Bruk kun move_and_slide() uten argumenter
