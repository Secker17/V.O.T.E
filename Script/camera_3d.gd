extends Camera3D

@export var follow_target: Node3D  # Karakteren kameraet skal følge
@export var offset: Vector3 = Vector3(0, 5, -10)  # Kameraets posisjon
@export var smooth_follow: bool = true  # Myk oppfølging
@export var follow_speed: float = 5.0  # Hastighet for oppfølging

func _process(delta: float) -> void:
	if not follow_target:
		return

	# Målposisjon for kameraet
	var target_position = follow_target.global_transform.origin + offset

	# Myk eller direkte oppfølging
	if smooth_follow:
		global_transform.origin = global_transform.origin.lerp(target_position, follow_speed * delta)
	else:
		global_transform.origin = target_position

	# Kamera ser på karakteren
	look_at(follow_target.global_transform.origin, Vector3.UP)
