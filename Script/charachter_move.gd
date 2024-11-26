extends CharacterBody3D

const SPEED = 15.0  # Movement speed
const JUMP_VELOCITY = 4.5  # Jump strength
@export var mouse_sensitivity: float = 0.2  # Mouse sensitivity for look controls

var yaw: float = 0.0  # Rotation around the Y-axis (horizontal)
var pitch: float = 0.0  # Rotation around the X-axis (vertical)

# Called when the node is added to the scene
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # Lock the mouse pointer for first-person controls

# Handles mouse input for looking around
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# Update yaw and pitch based on mouse movement
		yaw -= event.relative.x * mouse_sensitivity
		pitch = clamp(pitch - event.relative.y * mouse_sensitivity, -89.0, 89.0)

		# Apply rotation to the character and camera
		rotation_degrees.y = yaw
		$Camera.rotation_degrees.x = pitch

	# Allow mouse to be freed when pressing ESC
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

# Physics process to handle movement and gravity
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	# Move the character using velocity
	move_and_slide()
